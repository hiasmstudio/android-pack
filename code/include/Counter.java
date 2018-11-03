package hiasm.hiasmproject;

public class Counter {
	
	public static interface ICounter {
		public abstract void onCounter(double value);
		public abstract void onThroughMax();
		public abstract void onThroughMin();
	}
	
	public static final int MODE_DEC = -1;
	public static final int MODE_INC = 1;
	
	double mCurrent;
	double mDefault;
	ICounter mICounter;
	int mMode;
	
	public Counter(double defaultValue, int mode, ICounter iCounter) {
		mMode = mode;
		mCurrent = mDefault = defaultValue;
		mICounter = iCounter;
	}
	
	public double getValue() {
		return mCurrent;
	}
	
	public void next(double min, double max, double step) {
		mCurrent += step * mMode;
		if(mCurrent > max) {
			mCurrent = min;
			mICounter.onThroughMax();
		} else if(mCurrent < min) {
			mCurrent = max;
			mICounter.onThroughMin();
		}
		mICounter.onCounter(mCurrent);
	}
	
	public void prev(double min, double max, double step) {
		mCurrent -= step * mMode;
		if(mCurrent > max) {
			mCurrent = min;
			mICounter.onThroughMax();
		} else if(mCurrent < min) {
			mCurrent = max;
			mICounter.onThroughMin();
		}
		mICounter.onCounter(mCurrent);
	}
	
	public void reset() {
		mCurrent = mDefault;
	}
	
	public void setValue(double value) {
		mCurrent = value;
	}

}