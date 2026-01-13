# Logisim-evolution Verilog exporter

This tool builds a headless Verilog exporter around Logisim-evolution 4.0.0 and exposes a CLI:

```bash
java -jar logisim-export.jar input.circ output.v
```

## Build

```bash
tools/logisim-export/build.sh
```

The build script:

- Clones Logisim-evolution v4.0.0 into `third_party/logisim-evolution` if missing.
- Builds the Logisim-evolution shadow jar.
- Compiles the minimal exporter and produces `logisim-export.jar` at the repo root.

## Notes

The exporter loads the `.circ` file, generates Verilog via Logisim's internal HDL generator API, and
merges all emitted `.v` files into the single output file supplied on the command line.

## Logisim-evolution implementation references

Logisim-evolution's Verilog generation is ultimately driven by the HDL generator factories
(for circuits, `CircuitHdlGeneratorFactory`) and the shared `Hdl`/`FileWriter` helpers. The
GUI/FPGA flow triggers this through the FPGA download logic (e.g., `DownloadBase#writeHDL`), which
recursively calls `generateAllHDLDescriptions` and emits `.v` files via `Hdl.writeArchitecture`.
