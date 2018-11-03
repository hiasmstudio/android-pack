package hiasm.hiasmproject;

import java.io.BufferedInputStream;
import java.io.ByteArrayOutputStream;
import java.io.InputStream;
import java.util.ArrayList;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import org.apache.http.HttpResponse;
import org.apache.http.HttpStatus;
import org.apache.http.client.HttpClient;
import org.apache.http.client.methods.HttpGet;
import org.apache.http.impl.client.DefaultHttpClient;
import org.apache.http.params.BasicHttpParams;
import org.apache.http.params.HttpConnectionParams;
import org.apache.http.params.HttpParams;

import android.content.Context;
import android.widget.ArrayAdapter;

public class Methods {
	
  public static String[] splitStr (String str, String dlm, int max_parts)
  {
    String[] dst;
    int len1, len2;
    int idx1, idx2;
    int i = 0;
    ArrayList<String> slist;
    
    // Если искомая строка пустая, результат - массив с одной пустой строкой
    if (str == null || str.isEmpty())
    {
      dst = new String[1];
      dst[0] = "";
      return dst;
    }
    
    
    // Если разделитель пустой, результат - массив с одной строкой, равной исходной
    if (dlm == null || dlm.isEmpty() /*|| str.indexOf(dlm) == -1*/)
    {
      dst = new String[1];
      dst[0] = str;
      return dst;
    }
    
    
    len1 = str.length();
    len2 = dlm.length();
    
    slist = new ArrayList<String>((max_parts > 0)?max_parts:(len1 / len2));

    idx1 = 0;

    while (true)
    {
      if ((max_parts > 0) && (max_parts == i)) break;
      
      idx2 = str.indexOf(dlm, idx1);
      if ((idx2 == -1) || ((max_parts > 0) && (i == max_parts - 1)))
      {
        slist.add(str.substring(idx1, len1));
        break;
      }
      
      slist.add(str.substring(idx1, idx2));
      idx1 = idx2 + len2;
      i++;
    }

    return slist.toArray(new String[0]);
  }
  
  public static String formatStr (String mask, String symbol, String... args) 
  {
    String result = mask;
	  for (int i = 0; i < args.length; i++)
	    result = result.replace(symbol + (i+1), args[i]);
	  return result;
  }
  
  public static String byteArrayToHex(byte[] array) {
    StringBuilder builder = new StringBuilder();
    for(int i = 0; i < array.length; i++)
      builder.append(Integer.toHexString((int) array[i]));
    return builder.toString();	  
  }
  
  public static String stringToHex(String string) {
    return byteArrayToHex(string.getBytes());
  }
  
  public static byte[] hexToByteArray(String hexString) {
    ByteArrayOutputStream stream = new ByteArrayOutputStream();
	for(int i = 0; i < hexString.length(); i += 2)
	   stream.write(Integer.parseInt(hexString.substring(i, i+2), 16));
	return stream.toByteArray();
  }
  
  public static String hexToString(String hexString) {
	return new String(hexToByteArray(hexString));
  }
  
  public static byte[] readStreamFully(InputStream stream) {
    try {
      stream = new BufferedInputStream(stream);
      ByteArrayOutputStream outputStream = new ByteArrayOutputStream();
      byte[] buffer = new byte[1024];
      int count;
      while ((count = stream.read(buffer)) != -1)
        outputStream.write(buffer, 0, count);
      return outputStream.toByteArray();
	} catch (Exception e) {
	  e.printStackTrace();
	}
	return null;
  }
  
  public static byte[] readResource(Context context, int id) {
    return readStreamFully(context.getResources().openRawResource(id));
  }
  
  public static boolean isUrlReachable(String url, int timeout) {
		try {
		    HttpGet request = new HttpGet(url);
		    HttpParams httpParameters = new BasicHttpParams();  

		    HttpConnectionParams.setConnectionTimeout(httpParameters, timeout);
		    HttpClient httpClient = new DefaultHttpClient(httpParameters);
		    HttpResponse response = httpClient.execute(request);

		    int status = response.getStatusLine().getStatusCode();

		    if (status == HttpStatus.SC_OK) 
		    	return true;

		} catch (Exception e) {
			e.printStackTrace();
			return false;
		}
		return false;
  }
  
  private static String correctString(String string) {		
		return string.replace("\\", "\\\\").replace(".", "\\.")
				.replace("[", "\\[").replace("]", "\\]")
				.replace("^", "\\^").replace("$", "\\$")
				.replace("(", "\\(").replace(")", "\\)")
				.replace("|", "\\|").replace("*", "\\*")
				.replace("+", "\\+").replace("?", "\\?")
				.replace("{", "\\{").replace("}", "\\}")
				.replace("/", "\\/");
  }
  
  public static String[] findBlocks(String string, String start, String end, boolean include) throws Exception {	
		ArrayList<String> result = new ArrayList<String>();
		
		String expression = "(?s)" + correctString(start) + ".*?" + correctString(end);
		Pattern pattern = Pattern.compile(expression);
		Matcher matcher = pattern.matcher(string);
		
		while(matcher.find()) {
			if(include) {
				result.add(matcher.group());
			} else {
				String found = matcher.group();
				result.add(found.substring(start.length(), found.length() - end.length()));
			}
		}
		
		return result.toArray(new String[0]);
  }
  
  public static ArrayList<String> getStringsByAdapter(ArrayAdapter<String> adapter) {
	  ArrayList<String> strings = new ArrayList<String>();
	  for(int i = 0; i < adapter.getCount(); i++)
		  strings.add(adapter.getItem(i));
	  return strings;
  }
  
}