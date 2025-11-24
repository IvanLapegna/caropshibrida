package com.example.caropshibrida

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.util.Log

class DebugReceiver : BroadcastReceiver() {
    override fun onReceive(context: Context?, intent: Intent?) {
        Log.d("DebugReceiver", "onReceive action=${intent?.action} extras=${intent?.extras}")
    }
}