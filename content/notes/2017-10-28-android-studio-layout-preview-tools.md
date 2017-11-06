---
title: Android Studio Layout Preview Tools
kind: note
created_at: 2017-10-28 13:16:42 +0200
---

For those who are using the Android Studio layout preview (those who don't should!), you might already know the 
[`tools`](https://developer.android.com/studio/write/tool-attributes.html) namespace (`toolsNs` shortcut in Android Studio).

Here follows some steroids for such attributes:

- `tools:showIn` to integrate a layout in a parent for the preview (for nested layout/components)
- `tools:listitem` to apply a layout to children of list/recycler views
- `tools:...="@sample/..."` to apply concrete data source to a layout (iterate over list of data when layout is integrated into a list/recycler view)

You have built-in sample data:

``` xml
<LinearLayout xmlns:android="http://schemas.android.com/apk/res/android"
              xmlns:tools="http://schemas.android.com/tools"
              android:layout_width="match_parent"
              android:layout_height="match_parent"
              android:orientation="vertical">
  <TextView
    android:layout_width="wrap_content"
    android:layout_height="wrap_content"
    tools:text="@tools:sample/lorem"/>

  <TextView
    android:layout_width="wrap_content"
    android:layout_height="wrap_content"
    tools:text="@tools:sample/full_names"/>

  <TextView
    android:layout_width="wrap_content"
    android:layout_height="wrap_content"
    tools:text="@tools:sample/date_mmddyyyy"/>

  <TextView
    android:layout_width="wrap_content"
    android:layout_height="wrap_content"
    tools:text="@tools:sample/cities"/>

  <ImageView
    android:layout_width="wrap_content"
    android:layout_height="wrap_content"
    tools:src="@tools:sample/avatars"/>

  <!-- See Android Studio auto completion for further examples. -->

</LinearLayout>
```

And you can add custom text sample data using `src/main/sampledata/mydata` (New > Sample Data directory from your module):

``` text
line1
another line
line 3
and some content
...
```

Or using `src/main/sampledata/mydata.json`:
``` json
{
  "stuff": [
    {
      "label": "foo",
      "icon": "@drawable/ic_foo"
    },
    {
      "label": "bar",
      "icon": "@drawable/ic_bar"
    },
    {
      "label": "zorg",
      "icon": "@drawable/ic_zorg"
    }
  ]
}
```

You can now use it in your layout files using `@sample/*`.

``` xml
<LinearLayout xmlns:android="http://schemas.android.com/apk/res/android"
              xmlns:tools="http://schemas.android.com/tools"
              android:layout_width="match_parent"
              android:layout_height="match_parent"
              android:orientation="vertical">
  <TextView
    android:layout_width="wrap_content"
    android:layout_height="wrap_content"
    tools:text="@sample/mydata.json/stuff/label"/>

  <ImageView
    android:layout_width="wrap_content"
    android:layout_height="wrap_content"
    tools:src="@sample/mydata.json/stuff/icon"/>

  <!-- Android Studio can also auto complete from user defined sample data. -->

</LinearLayout>
```

The cool thing is that Android Studio provides auto completion even for your custom sample data (need rebuild of project).

![Android Studio with sample data](/images/as_preview_toolsns.png)

