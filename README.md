# ⚡ FPGA UART Serial Transmitter

A parameterized, synthesizable Universal Asynchronous Receiver-Transmitter (UART) module designed in Verilog HDL. This project demonstrates core digital design principles required for ASIC/FPGA flows, including Finite State Machine (FSM) architecture, clock division, and shift-register data framing.

## 📌 Architecture & Logic Design
* **Transmission Protocol:** Standard RS-232 serial framing (1 Start Bit, 8 Data Bits, 1 Stop Bit, No Parity).
* **Control Logic:** Implemented using a 4-state Moore Finite State Machine (IDLE, START, DATA, STOP).
* **Clock Divider:** Fully parameterized `CLKS_PER_BIT` constant allows the module to adapt to any host FPGA clock frequency and target baud rate (e.g., 50MHz clock generating a 115200 baud rate).
* **Hardware Interfacing:** The module features a `tx_busy` flag to prevent data collision from the host processor during active transmission cycles.

## 🛠️ Technical Specifications
* **Hardware Description Language:** Verilog HDL (IEEE 1364)
* **Design Target:** FPGA / ASIC Synthesis
* **Operating Logic:** Synchronous Edge-Triggered Sequential Logic

---
*Developed by Rajeswari S. | Electronics and Communication Engineering (2023–2027)*
