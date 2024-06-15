package com.ac.motdujour;

import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import androidx.work.PeriodicWorkRequest;
import androidx.work.WorkManager;
import androidx.work.WorkRequest;
import java.util.concurrent.TimeUnit;

public class BootBroadcastReceiver extends BroadcastReceiver {

    @Override
    public void onReceive(Context context, Intent intent) {
        if (Intent.ACTION_BOOT_COMPLETED.equals(intent.getAction())) {
            // Reschedule the daily notification
            WorkRequest dailyWorkRequest = new PeriodicWorkRequest.Builder(NotificationWorker.class, 24, TimeUnit.HOURS)
                    .build();
            WorkManager.getInstance(context).enqueue(dailyWorkRequest);
        }
    }
}
