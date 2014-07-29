---
layout: post
title: "Android Custom Layout: FlowLayout"
category: programming
tags: [android, java, ui]
---

Hello, Android devs! This is my first blog about Android. We know Android SDK provides you a bunch
of useful layouts: `FrameLayout`, `LinearLayout`, `RelativeLayout`, etc. So where is `FlowLayout`,
which works like a multiline `TextView` but holding views instead of texts? Developers can just add
views to a `FlowLayout` and each view is put to the right of the previous one and wraps to a new row
when the current row is full. I'm gonna show you how you could implement your own `FlowLayout` with
less than 100 lines of code.

<!-- more start -->

## Prerequisites

To understand this tutorial, you should have some Android development experience. You should already
know what views and viewgroups are. You also should have used one of the SDK builtin layouts before.

## How it works

A layout should subclass
[ViewGroup](http://developer.android.com/reference/android/view/ViewGroup.html) and implement
`onMeasure()` and `onLayout()`. `onMeasure(int, int)` is called when the parent of this view wants
to know this view's dimension, `onLayout(boolean, int, int, int, int)` is called when the parent
layouts this view. Since a layout has its own children, it should also layout them in `onLayout()`.

So we basically do two things, calculate the size of the layout in `onMeasure()` and layout the
children in `onLayout()`.

## The code

In `onMeasure()`, we go through all children, measure each child and put the child to the right of
previous child if there's enough room for it. Otherwise, wrap the line and put the child to next
line. At last, we know how much room the layout itself want to be to hold all its children.

{%highlight java%}
@Override
protected void onMeasure(int widthMeasureSpec, int heightMeasureSpec) {
  int childLeft = getPaddingLeft();
  int childTop = getPaddingTop();
  int lineHeight = 0;
  // 100 is a dummy number, widthMeasureSpec should always be EXACTLY for FlowLayout
  int myWidth = resolveSize(100, widthMeasureSpec);
  int wantedHeight = 0;
  for (int i = 0; i < getChildCount(); i++) {
    final View child = getChildAt(i);
    if (child.getVisibility() == View.GONE) {
      continue;
    }
    // let the child measure itself
    child.measure(
        getChildMeasureSpec(widthMeasureSpec, getPaddingLeft() + getPaddingRight(),
            child.getLayoutParams().width),
        getChildMeasureSpec(heightMeasureSpec, getPaddingTop() + getPaddingBottom(),
            child.getLayoutParams().height));
    int childWidth = child.getMeasuredWidth();
    int childHeight = child.getMeasuredHeight();
    // lineheight is the height of current line, should be the height of the heightest view
    lineHeight = Math.max(childHeight, lineHeight);
    if (childWidth + childLeft + getPaddingRight() > myWidth) {
      // wrap this line
      childLeft = getPaddingLeft();
      childTop += paddingVertical + lineHeight;
      lineHeight = childHeight;
    }
    childLeft += childWidth + paddingHorizontal;
  }
  wantedHeight += childTop + lineHeight + getPaddingBottom();
  setMeasuredDimension(myWidth, resolveSize(wantedHeight, heightMeasureSpec));
}
{%endhighlight%}

`onLayout()` basicly does the same thing except it layouts the children instead of calculating the
dimension.

{%highlight java%}
@Override
protected void onLayout(boolean changed, int left, int top, int right, int bottom) {
  int childLeft = getPaddingLeft();
  int childTop = getPaddingTop();
  int lineHeight = 0;
  int myWidth = right - left;
  for (int i = 0; i < getChildCount(); i++) {
    final View child = getChildAt(i);
    if (child.getVisibility() == View.GONE) {
      continue;
    }
    int childWidth = child.getMeasuredWidth();
    int childHeight = child.getMeasuredHeight();
    lineHeight = Math.max(childHeight, lineHeight);
    if (childWidth + childLeft + getPaddingRight() > myWidth) {
      childLeft = getPaddingLeft();
      childTop += paddingVertical + lineHeight;
      lineHeight = childHeight;
    }
    child.layout(childLeft, childTop, childLeft + childWidth, childTop + childHeight);
    childLeft += childWidth + paddingHorizontal;
  }
}
{%endhighlight%}

To make use of our fresh new `FlowLayout`, put it in an activity and add some views into it.

{%highlight java%}
public class MainActivity extends Activity {
  @Override
  protected void onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);
    setContentView(R.layout.activity_main);
    ViewGroup flowContainer = (ViewGroup) findViewById(R.id.flow_container);
    for (Locale locale : Locale.getAvailableLocales()) {
      String countryName = locale.getDisplayCountry();
      if (!countryName.isEmpty()) {
        flowContainer.addView(createDummyTextView(countryName),
            new LayoutParams(LayoutParams.WRAP_CONTENT, LayoutParams.WRAP_CONTENT));
      }
    }
  }
 
  private View createDummyTextView(String text) {
    TextView textView = new TextView(this);
    textView.setText(text);
    return textView;
  }
}
{%endhighlight%}

We add the country name of all locale available on this device into a FlowLayout and see how it
works:

![](/image/flowlayout_portrait.png)

![](/image/flowlayout_landscape.png)

The full code lives on [gist](https://gist.github.com/hzqtc/7940858).

<!-- more end -->
