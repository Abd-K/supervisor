package com.example.supervisor

import android.os.Bundle
import android.view.WindowManager
import io.flutter.embedding.android.FlutterActivity

class MainActivity : FlutterActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        // Prevent Flutter window from resizing/panning when keyboard opens
        window.setSoftInputMode(
            WindowManager.LayoutParams.SOFT_INPUT_ADJUST_NOTHING or
            WindowManager.LayoutParams.SOFT_INPUT_STATE_HIDDEN
        )
    }
}