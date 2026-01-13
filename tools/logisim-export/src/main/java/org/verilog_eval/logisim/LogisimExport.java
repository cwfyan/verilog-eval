package org.verilog_eval.logisim;

import com.cburch.logisim.Main;
import com.cburch.logisim.circuit.Circuit;
import com.cburch.logisim.file.Loader;
import com.cburch.logisim.file.LoadFailedException;
import com.cburch.logisim.file.LogisimFile;
import com.cburch.logisim.fpga.designrulecheck.CorrectLabel;
import com.cburch.logisim.fpga.hdlgenerator.HdlGeneratorFactory;
import com.cburch.logisim.prefs.AppPreferences;
import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.Path;
import java.util.Comparator;
import java.util.HashSet;
import java.util.List;

public final class LogisimExport {
  private LogisimExport() {}

  public static void main(String[] args) {
    if (args.length != 2) {
      System.err.println("Usage: java -jar logisim-export.jar <input.circ> <output.v>");
      System.exit(2);
    }

    final var inputPath = Path.of(args[0]);
    final var outputPath = Path.of(args[1]);

    if (!Files.exists(inputPath)) {
      System.err.println("Input file does not exist: " + inputPath);
      System.exit(2);
    }

    try {
      exportVerilog(inputPath, outputPath);
      System.exit(0);
    } catch (Exception e) {
      e.printStackTrace(System.err);
      System.exit(1);
    }
  }

  private static void exportVerilog(Path inputPath, Path outputPath)
      throws IOException, LoadFailedException {
    Main.headless = true;
    AppPreferences.HdlType.set(HdlGeneratorFactory.VERILOG);

    final var loader = new Loader(null);
    final var file = loader.openLogisimFile(inputPath.toFile());
    if (file == null) {
      throw new IOException("Failed to load Logisim file: " + inputPath);
    }

    final var circuit = file.getMainCircuit();
    if (circuit == null) {
      throw new IOException("No main circuit found in file: " + inputPath);
    }

    final var generator = circuit.getSubcircuitFactory().getHDLGenerator(circuit.getStaticAttributes());
    if (generator == null) {
      throw new IOException("HDL generator not available for circuit: " + circuit.getName());
    }

    final var tempDir = Files.createTempDirectory("logisim-export");
    try {
      final var handled = new HashSet<String>();
      if (!generator.generateAllHDLDescriptions(handled, tempDir.toString(), null)) {
        throw new IOException("HDL generation failed for circuit: " + circuit.getName());
      }

      final var verilogRoot = tempDir.resolve(generator.getRelativeDirectory());
      final var verilogFiles = collectVerilogFiles(verilogRoot);
      if (verilogFiles.isEmpty()) {
        throw new IOException("No Verilog output found in: " + verilogRoot);
      }

      writeMergedVerilog(verilogFiles, outputPath, circuit, verilogRoot);
    } finally {
      deleteTree(tempDir);
    }
  }

  private static List<Path> collectVerilogFiles(Path verilogRoot) throws IOException {
    if (!Files.exists(verilogRoot)) {
      return List.of();
    }
    try (var stream = Files.walk(verilogRoot)) {
      return stream
          .filter(path -> path.toString().endsWith(".v"))
          .sorted(Comparator.naturalOrder())
          .toList();
    }
  }

  private static void writeMergedVerilog(
      List<Path> verilogFiles,
      Path outputPath,
      Circuit circuit,
      Path verilogRoot)
      throws IOException {
    final var parent = outputPath.getParent();
    if (parent != null) {
      Files.createDirectories(parent);
    }

    try (var writer = Files.newBufferedWriter(outputPath, StandardCharsets.UTF_8)) {
      writer.write("// Logisim-evolution Verilog export\n");
      writer.write("// Source circuit: " + CorrectLabel.getCorrectLabel(circuit.getName()) + "\n\n");
      for (var file : verilogFiles) {
        final var relative = verilogRoot.relativize(file);
        writer.write("// ---- Begin: " + relative + "\n");
        Files.lines(file, StandardCharsets.UTF_8).forEach(line -> {
          try {
            writer.write(line);
            writer.newLine();
          } catch (IOException e) {
            throw new RuntimeException(e);
          }
        });
        writer.write("// ---- End: " + relative + "\n\n");
      }
    }
  }

  private static void deleteTree(Path root) throws IOException {
    if (!Files.exists(root)) {
      return;
    }
    try (var stream = Files.walk(root)) {
      var paths = stream.sorted(Comparator.reverseOrder()).toList();
      for (var path : paths) {
        Files.deleteIfExists(path);
      }
    }
  }
}
