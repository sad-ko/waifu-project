//	------------------------------------------------------------------------------	//
package waifu_project;
//	------------------------------------------------------------------------------	//
import java.io.File;
import java.io.FileWriter;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;
import java.util.Locale;
import java.util.Scanner;
//	------------------------------------------------------------------------------	//
public class Files {
//	------------------------------------------------------------------------------	//
	public static <T> T read(final String filename, ReaderLambda<T> lambda, List<T> list) {
		Scanner scanner = null;
		T rc = null;
		
		try {
			File file = new File(filename);
			scanner = new Scanner(file);
			scanner.useLocale(Locale.ENGLISH);
			rc = lambda.read_method(scanner, list);
		} catch(Exception e) {
			System.err.println("[ERROR] - Can't open file: " + filename);
		} finally {
			if (scanner != null) {
				scanner.close();
			}
		}
		
		return rc;
	}
//	------------------------------------------------------------------------------	//
	public static <T> void write(final String filename, boolean append, WriterLambda<T> lambda, List<T> list) {
		FileWriter file = null;
		PrintWriter printerWriter = null;

		try {
			file = new FileWriter(filename, append);
			printerWriter = new PrintWriter(file);
			lambda.write_method(printerWriter, list);
		} catch (Exception e) {
			System.err.println("[ERROR] - Can't open file: " + filename);
		} finally {
			if (file != null) {
				try {
					file.close();
				} catch (IOException e) {
					e.printStackTrace();
				}
			}
		}
	}
//	------------------------------------------------------------------------------	//
}
//	------------------------------------------------------------------------------	//
