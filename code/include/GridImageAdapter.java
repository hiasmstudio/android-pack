package hiasm.hiasmproject;

import android.content.Context;
import android.graphics.Bitmap;
import android.graphics.drawable.BitmapDrawable;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.ImageView;
import android.widget.GridView;
import java.util.ArrayList;


public class GridImageAdapter extends BaseAdapter 
{
	
  private Context mContext;
  public ArrayList<ImageView> imageList;
  
  private ImageParams imgAttrs;

  public GridImageAdapter(Context c, GridImageAdapter.ImageParams attrs) 
  {
    ImageView img;
    mContext = c;
    imgAttrs = attrs;
    imageList = new ArrayList<ImageView>();
  }

  public int getCount() 
  {
    return imageList.size();
  }

  public Object getItem(int position) 
  {
    return null; // Вернуть битмап?
  }

  public long getItemId(int position) 
  {
      return 0; // Вернуть номер строки?
  }

  public View getView(int position, View convertView, ViewGroup parent) 
  {
    return imageList.get(position);
  }
  
  public void addFromResource(int resourceId)
  {
    ImageView img;
    img = createView();
    img.setImageResource(resourceId);
    imageList.add(img);
    notifyDataSetChanged();
  }
  
  public void addFromResource(int[] arrayOfResourceIds)
  {
    ImageView img;
    if (arrayOfResourceIds != null)
    {
      for (int i = 0; i < arrayOfResourceIds.length; i++)
      {
        img = createView();
        img.setImageResource(arrayOfResourceIds[i]);
        imageList.add(img);
      }
      notifyDataSetChanged();
    }
  }
  
  public void setFromResource(int resourceId, int idx)
  {
    if (idx > -1 && idx < imageList.size())
    {
      imageList.get(idx).setImageResource(resourceId);
      //notifyDataSetChanged();
    }
  }
  
  
  public void addBitmap(Bitmap bmp)
  {
    ImageView img;
    if (bmp != null)
    {
      img = createView();
      img.setImageBitmap(bmp);
      imageList.add(img);
      notifyDataSetChanged();
    }
  }
  
  public void setBitmap(Bitmap bmp, int idx)
  {
    if (bmp != null && idx > -1 && idx < imageList.size())
    {
      imageList.get(idx).setImageBitmap(bmp);
      //notifyDataSetChanged();
    }
  }
  
  public Bitmap getBitmap(int idx)
  {
    if (idx > -1 && idx < imageList.size())
    {
      return ((BitmapDrawable) imageList.get(idx).getDrawable()).getBitmap();
    }
    else return null;
  }
  
  private ImageView createView()
  {
    ImageView img;
    img = new ImageView(mContext);
    if (imgAttrs != null)
    {
      img.setLayoutParams(new GridView.LayoutParams(imgAttrs.width, imgAttrs.height));
      img.setScaleType(imgAttrs.scaleType);
      img.setMaxWidth(imgAttrs.maxWidth);
      img.setMaxHeight(imgAttrs.maxHeight);
    }
    else
    {
      img.setScaleType(ImageView.ScaleType.CENTER);
    }
    return img;
  }
  
  
  public static class ImageParams
  {
    public int width;
    public int height;
    public int maxWidth;
    public int maxHeight;
    public ImageView.ScaleType scaleType;
    
    public ImageParams(int width, int height, int maxWidth, int maxHeight, ImageView.ScaleType scaleType)
    {
      this.width = width;
      this.height = height;
      this.maxWidth = maxWidth;
      this.maxHeight = maxHeight;
      this.scaleType = scaleType;
    }
  }
}
