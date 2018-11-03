package hiasm.hiasmproject;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collection;
import java.util.Collections;

public class StringList {
	
	public static final int POSITION_START = -1;
	public static final int POSITION_END = -2;
	
	private ArrayList<String> mList = new ArrayList<String>();
	
	private String listToString(ArrayList<String> list) {
		StringBuilder builder = new StringBuilder();
		
		for(int i = 0; i < list.size(); i++) {
			builder.append(list.get(i));
			if(i < list.size() - 1) builder.append("\n");
		}

		return builder.toString();
	}

	public StringList() {

	}

	public StringList(String string) {
		mList = new ArrayList<String>(Arrays.asList(string.split("\n")));
	}

	public StringList(String[] array) {
		mList = new ArrayList<String>(Arrays.asList(array));
	}

	public StringList(Collection<String> collection) {
		mList = new ArrayList<String>(collection);
	}

	public void add(String string, int position) {
		if(position == POSITION_START) mList.add(0, string);
		else if(position == POSITION_END) mList.add(string);
		else mList.add(position, string);
	}

	public void clear() {
		mList.clear();
	}

	public void delete(int index) {
		mList.remove(index);
	}

	public void loadFile(String filePath) throws Exception {
		File file = new File(filePath);
		FileInputStream inputStream = new FileInputStream(file);
		byte[] buffer = new byte[(int) file.length()];
		inputStream.read(buffer);
		mList = new ArrayList<String>(
				Arrays.asList(new String(buffer).split("\n")));
		inputStream.close();
	}

	public void saveFile(String filePath) throws Exception {
		File file = new File(filePath);
		if(!file.exists())
			file.createNewFile();
		FileOutputStream outputStream = new FileOutputStream(file);
		outputStream.write(listToString(mList).getBytes());
		
		outputStream.close();
	}
	
	public void sort() {
		Collections.sort(mList);
	}

	public ArrayList<String> getList() {
		return mList;
	}
	
	public String[] getArray() {
		return mList.toArray(new String[0]);
	}
	
	public int getCount() {
		return mList.size(); 
	}
	
	@Override
	public String toString() {
		return listToString(mList);
	}
	
}