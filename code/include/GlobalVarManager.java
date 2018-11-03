package hiasm.hiasmproject;

import java.util.HashMap;

public class GlobalVarManager {

	static HashMap<String, Memory> mVarsMap = new HashMap<String, Memory>();
	
	public static void addVar(String name, Memory value) {
		mVarsMap.put(name, value);
	}
	
	public static Memory getVar(String name) {
		Memory var = mVarsMap.get(name);
		if(var == null) var = new Memory();
		return var;
	}

}
