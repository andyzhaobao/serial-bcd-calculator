# Serial BCD Calculator

A stream-in/stream-out 4-digit BCD calculator in Verilog. The design receives a
framed serial payload, performs decimal addition or subtraction, and transmits a
framed serial result. The full protocol and datapath are built from scratch — no
external IP or vendor primitives.

Coursework project, NC State University. Simulated and synthesized in Xilinx Vivado.

---

## Interface

| Signal | Dir | Width | Description |
|---|---|---|---|
| `clk` | in | 1 | System clock |
| `rst` | in | 1 | Synchronous reset |
| `serial_in` | in | 1 | Incoming bit stream |
| `serial_out` | out | 1 | Outgoing bit stream |
| `valid_out` | out | 1 | Asserted while a result frame is being transmitted |

<!-- Update this table to match your actual port list. -->

**Input frame:** an 8-bit start-of-frame byte followed by a 33-bit payload
(`{op, A[15:0], B[15:0]}`), where `op` selects addition or subtraction and `A`/`B`
are 4-digit packed BCD operands.

**Output frame:** a 28-bit framed serial stream carrying the header and the
4-digit packed BCD result.

---

## Architecture

Five RTL modules:

| Module | Role |
|---|---|
| `sof_detect` | 8-bit sliding comparator detecting the start-of-frame byte |
| `deserializer` | Captures the 33-bit payload (SIPO) into the operand registers |
| `bcd_addsub` | 4-digit decimal add/subtract unit |
| `serializer` | Emits the 28-bit framed result (PISO) |
| `control_fsm` | Sequences receive → compute → transmit and gates frame detection |

<!-- docs/block-diagram.png -->

### Decimal arithmetic

Built bottom-up from gate primitives rather than using the `+` operator:

```
full adder → 4-bit ripple-carry adder → BCD digit adder (add-6 correction) → 4-digit carry chain
```

Each digit adder performs a binary add and applies the add-6 correction when the
result exceeds 9 or produces a carry, keeping every digit in valid BCD range.

Subtraction reuses the same adder tree via **ten's complement**: each digit of
the subtrahend is replaced by its 9's complement and the carry-in of the least
significant digit is asserted. A single adder tree therefore serves both
operations, with no separate subtractor.

---

## The frame-sync bug

**Symptom.** Certain valid transactions produced corrupted results. The receiver
would restart capture partway through a payload, discarding operand bits already
received and re-aligning to the wrong bit boundary.

**Root cause.** The start-of-frame comparator ran continuously against the input
stream. When payload data happened to contain the 8-bit sync pattern — which is
possible for many legitimate operand values — the comparator fired mid-transaction
and reset the deserializer.

**Fix.** The comparator is now gated by a hold-off signal from the receive FSM.
Once a frame is detected, frame detection is disabled until the payload is fully
captured and the transaction completes. Payload bytes that alias the sync pattern
are treated as data, which is what they are.

This is a general hazard in any serial protocol without byte stuffing or an escape
mechanism, and it only appears with specific operand values — which is why it
survived the first round of directed tests.

---

## Verification

A bit-level testbench drives complete serial transactions at the pin, rather than
loading internal registers directly, so the frame detection, deserialization,
arithmetic, and output framing are all exercised end to end.

Cases covered:

- Addition across the operand range
- Subtraction, including borrow propagation across digits
- Payloads containing the sync pattern (the regression test for the bug above)
- Header emission and completion signaling on the output frame

The testbench checks the framed output stream rather than internal state.

<!-- docs/waveform-add.png -->

---

## Running it

```
# Vivado batch simulation
vivado -mode batch -source sim/run_sim.tcl
```

<!-- Replace with whatever your actual flow is; if you ran it through the GUI,
     say so and list the top module name instead. -->

---

## Repository layout

```
rtl/     Design sources
tb/      Testbench
docs/    Block diagram and waveform captures
sim/     Simulation scripts
```

---

## Notes

Posted publicly with the instructor's permission. If you are currently enrolled
in this course, submitting this work as your own is an academic integrity
violation — read it for the ideas, write your own.
