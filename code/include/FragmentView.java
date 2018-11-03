package hiasm.hiasmproject;

import android.content.Context;
import android.support.v4.app.Fragment;
import android.support.v4.app.FragmentTransaction;
import android.support.v7.app.ActionBarActivity;
import android.util.AttributeSet;
import android.widget.FrameLayout;

public class FragmentView extends FrameLayout {

	public FragmentView(Context context) {
		super(context);
	}

	public FragmentView(Context context, AttributeSet attrs) {
		super(context, attrs);
	}

	public FragmentView(Context context, AttributeSet attrs, int defStyle) {
		super(context, attrs, defStyle);
	}
	
	public void setFragment(Fragment fragment) {
		((ActionBarActivity) getContext()).getSupportFragmentManager()
				.beginTransaction().setTransition(FragmentTransaction.TRANSIT_FRAGMENT_OPEN)
				.replace(getId(), fragment).commit();
	}
	
	public void setFragment(Fragment fragment, Fragment parent) {
		parent.getChildFragmentManager()
				.beginTransaction().setTransition(FragmentTransaction.TRANSIT_FRAGMENT_OPEN)
				.replace(getId(), fragment).commit();
	}

}
