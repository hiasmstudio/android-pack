package hiasm.hiasmproject;

import java.util.HashMap;

public class DataNotifier {
	
	public interface OnNotifyListener {
		public abstract void onNotify(Memory data);
	}
	
	static HashMap<OnNotifyListener, String> mListeners = new HashMap<OnNotifyListener, String>();
	
	public static void registerListener(String name, OnNotifyListener listener) {
		mListeners.put(listener, name);
	}
	
	public static void notify(String name, Memory data) {
		OnNotifyListener[] listeners = mListeners.keySet().toArray(new OnNotifyListener[0]);
		for(OnNotifyListener listener : listeners) {
			if(mListeners.get(listener).equals(name)) {
				listener.onNotify(data);
			}
		}
	}
	
}
