package com.retrytech.bubbly_camera

import android.app.Activity
import android.content.Context
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.StandardMessageCodec
import io.flutter.plugin.platform.PlatformView
import io.flutter.plugin.platform.PlatformViewFactory

class NativeViewFactory(val channel: MethodChannel) :
    PlatformViewFactory(StandardMessageCodec.INSTANCE) {
    override fun create(context1: Context?, viewId: Int, args: Any?): PlatformView {
        val creationParams = args as Map<String?, Any?>?

//        return NativeView(context1, viewId, creationParams, channel);
        return CameraXView(context1 as Activity?, viewId, creationParams, channel);
    }
}
