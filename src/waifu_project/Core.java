//	------------------------------------------------------------------------------	//
package waifu_project;
//	------------------------------------------------------------------------------	//
import java.io.BufferedReader;
import java.io.File;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.List;
import java.util.Scanner;
//	------------------------------------------------------------------------------	//
public class Core {
//	------------------------------------------------------------------------------	//
	final private String shortcut_dir = "configs/";
	final private String shortcut_filename = "configs/remember.wa";
//	------------------------------------------------------------------------------	//
	private void say(String msg) {
		System.out.println(msg);
	}
//	------------------------------------------------------------------------------	//
	private void run(String to_run) {
		try {
			Process process = Runtime.getRuntime().exec(to_run);

			StringBuilder output = new StringBuilder();
			BufferedReader reader = new BufferedReader(new InputStreamReader(process.getInputStream()));

			String line;
			while ((line = reader.readLine()) != null) {
				output.append(line);
			}

			int exitVal = process.waitFor();
			if (exitVal == 0) {
				System.out.println(output);
			}
		} catch (IOException e) {
			e.printStackTrace();
		} catch (InterruptedException e) {
			e.printStackTrace();
		}
	}
//	------------------------------------------------------------------------------	//
	public void updateRemember(PrintWriter print_writer, List<String> list) {
		print_writer.println(list.get(0));
	}
//	------------------------------------------------------------------------------	//
	public String findShortcut(Scanner scanner, List<String> list) {
		String str;
		String[] splited;

		while (scanner.hasNextLine()) {
			str = scanner.nextLine();
			splited = str.split("::");

			if (splited[0].equals(list.get(0))) {
				return splited[1];
			}
		}
		return "";
	}
//	------------------------------------------------------------------------------	//
	private void add(String shortcut_name, String command) {
		if (shortcut_name.equals("-help") || command == null) {
			say("add: Creates a shortcut for your favorites commands!");
			say("Usage: add <shortcut name> <command to save>\n\tdo <shortcut name>");
			return;
		}

		String shortcut_toSave = shortcut_name + "::" + command;
		List<String> list_args = new ArrayList<String>();
		list_args.add(shortcut_toSave);

		File file = new File(this.shortcut_filename);
		
		if (file.exists() == false) {
			new File(this.shortcut_dir).mkdir();
		} else if (file.isDirectory() == false) {
			List<String> aux_list = new ArrayList<String>();
			aux_list.add(shortcut_name);
			
			String shortcut_repeated = Files.read(this.shortcut_filename, this::findShortcut, aux_list);
			
			if (shortcut_repeated.isEmpty() == false) {
				say(shortcut_name + " has been previously added.");
				return;
			}
		}
		
		if (file.isDirectory() == false) {
			Files.write(this.shortcut_filename, true, this::updateRemember, list_args);
		}
		
		System.out.println(shortcut_name + " was saved successfully!");
	}
//	------------------------------------------------------------------------------	//
	private void _do(String shortcut_name) {
		if (shortcut_name.equals("-help")) {
			say("do: Executes your favorites commands!");
			say("Usage: add <shortcut name> <command to save>\n\tdo <shortcut name>");
			return;
		}

		File file = new File(this.shortcut_filename);

		if (file.exists() && file.isDirectory() == false) {
			List<String> list_args = new ArrayList<String>();
			list_args.add(shortcut_name);
			
			String to_do = Files.read(this.shortcut_filename, this::findShortcut, list_args);

			run(to_do);
			say("Doing " + shortcut_name + " !!");
			say("Debug: " + to_do);
		} else {
			say("[ERROR] - No shortcuts had been added to the list.");
		}
	}
//	------------------------------------------------------------------------------	//
	public void start(String[] args) throws Exception {
		String commands = "";

		for (int i = 1; i < args.length; i++) {
			commands += args[i];
			commands += (i == args.length - 1) ? "" : " ";
		}

		switch (args[0]) {
		case "run":
			if (commands.isEmpty() == false) {
				run(commands);
			}
			break;

		case "say":
			if (commands.isEmpty() == false) {
				run("echo " + commands);
			}
			break;

		case "add":
			if (args.length >= 3) {
				add(args[1], commands.substring(args[1].length()).trim());
			} else if (args.length >= 2) {
				add(args[1], null);
			}
			break;

		case "do":
			if (commands.isEmpty() == false) {
				_do(commands);
			}
			break;
		
		default:
			say("");
		}
	}
//	------------------------------------------------------------------------------	//
	public static void main(String[] args) {
		if (args.length == 0) {
			System.err.println("[ERROR] - No arguments had been specified.");
			System.exit(1);
		}

		Core c = new Core();
		try {
			c.start(args);
		} catch (Exception e) {
			c.say("Core did not work as expected.");
		}
	}
//	------------------------------------------------------------------------------	//
}
//	------------------------------------------------------------------------------	//
