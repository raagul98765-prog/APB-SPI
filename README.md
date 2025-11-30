🧩 APB-SPI Controller (RTL Design)

A complete SPI (Serial Peripheral Interface) controller designed using Verilog RTL, integrated with an APB (Advanced Peripheral Bus) interface.
This project includes RTL design, testbenches, simulation, and synthesis-ready lint-clean code.


---

📁 Project Structure

APB-SPI/
│
├── rtl/
│   ├── APB_slave.v
│   ├── baudrate.v
│   ├── shifter.v
│   ├── slave_sel.v
│   └── top_module.v
│
├── tb/
│   ├── APB_slave_tb.v
│   ├── baud_gen_tb.v
│   ├── shifter_tb.v
│   ├── slave_sel_tb.v
│   └── top_module_tb.v
│
├── sim/
│   └── (simulation outputs / waveforms)
│
└── README.md


---

🔧 Tools Used

Tool	Purpose

Xilinx ISE 14.7	RTL design & simulation
Synopsys Design Compiler (DC)	Synthesis & netlist generation

---

🧱 RTL Blocks Implemented

This project includes all core components needed for a full SPI controller:

✔ 1. APB Slave Interface (APB_slave.v)

Receives read/write commands from APB bus

Generates internal registers for SPI control/status

Provides PRDATA, PREADY, PSLVERR


✔ 2. Baud Rate Generator (baudrate.v)

Divides input clock to generate SPI SCLK

Supports configurable baud rates


✔ 3. Shifter (shifter.v)

Handles MOSI/MISO data shifting

Supports 8-bit and 16-bit transfers

CPOL/CPHA mode-aware operation


✔ 4. Slave Select Logic (slave_sel.v)

Selects one slave among multiple SPI slaves

Supports dynamic slave selection through APB registers


✔ 5. Top-Level SPI Module (top_module.v)

Integrates all sub-blocks

Acts as the SPI Master

Connects to APB bus and external SPI slave



---

🧪 Verification

Testbenches cover:

APB read/write transactions

SPI full-duplex data transfer

Baud rate correctness

Slave select behavior

CPOL/CPHA modes


Waveforms were verified in:

Xilinx ISE Simulator

GTKWave (optional)



---

🚀 Features

Fully synchronous SPI protocol

Supports CPOL = 0/1, CPHA = 0/1

Configurable baud rate

Status & control via APB registers

Lint-clean RTL (synthesis-friendly)

Modular design for reuse in SoC environments



🧑‍💻 Author

Raagul S
