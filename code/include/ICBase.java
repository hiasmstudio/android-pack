package hiasm.hiasmproject;

import android.content.Context;
import android.util.Log;

public class ICBase {
	
	public interface OnErrorListener {		
		public abstract void onError(Throwable throwable);	
	}
	
	Context mContext;
	OnErrorListener mOnErrorListener;
	int mId;
	
	public ICBase() {
		
	}
	
	public void callEvent(String name) {
		callEvent(name, new Memory());
	}
	
	private void callEventCore(String name, Memory data) {
		try {
			mContext.getClass().getMethod(name + "_" + mId, Memory.class).invoke(mContext, data);
		} catch (Exception e) {
			if(mOnErrorListener != null)
				mOnErrorListener.onError(e);
			e.printStackTrace();
		}
	}
	
	public void callEvent(String name, Object data) {
		if(data instanceof Memory)
			callEventCore(name, (Memory) data);
		else callEventCore(name, new Memory().setValue(data));
	}
	
	public void callEvent(String name, byte data) {
		callEventCore(name, new Memory().setValue(data));
	}
	
	public void callEvent(String name, boolean data) {
		callEventCore(name, new Memory().setValue(data));
	}
	
	public void callEvent(String name, char data) {
		callEventCore(name, new Memory().setValue(data));
	}
	
	public void callEvent(String name, int data) {
		callEventCore(name, new Memory().setValue(data));
	}
	
	public void callEvent(String name, short data) {
		callEventCore(name, new Memory().setValue(data));
	}
	
	public void callEvent(String name, double data) {
		callEventCore(name, new Memory().setValue(data));
	}
	
	public void callEvent(String name, float data) {
		callEventCore(name, new Memory().setValue(data));
	}
	
	public void callEvent(String name, long data) {
		callEventCore(name, new Memory().setValue(data));
	}
	
	public Context getContext() {
		return mContext;
	}
	
	public void init() {
		
	}
	
	public void log(String text) {
		Log.d(getClass().getName(), text);
	}
	
	public void setContext(Context context) {
		mContext = context;
	}
	
	public void setId(int id) {
		mId = id;
	}
	
	public void setOnErrorListener(OnErrorListener listener) {
		mOnErrorListener = listener;
	}
	
}