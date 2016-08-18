package com.hiasmproject;

import com.hiasm.pack.HiActivity;
import android.widget.Toast;

public class MainActivity extends HiActivity {
	@Override
	protected void onCreate() {
Toast.makeText(getHiContext(), "123", Toast.LENGTH_SHORT).show();
	}
	@Override
	protected void onDestroy() {
	}
}
