package com.ac.wordoftheday;

import android.app.NotificationChannel;
import android.app.NotificationManager;
import android.content.Context;
import android.os.Build;
import androidx.annotation.NonNull;
import androidx.core.app.NotificationCompat;
import androidx.work.Worker;
import androidx.work.WorkerParameters;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.Random;

public class NotificationWorker extends Worker {

    public NotificationWorker(@NonNull Context context, @NonNull WorkerParameters params) {
        super(context, params);
    }

    @NonNull
    @Override
    public Result doWork() {
        // Generate the notification
        sendNotification();
        return Result.success();
    }

    private void sendNotification() {
        Context context = getApplicationContext();
        NotificationManager notificationManager = (NotificationManager) context.getSystemService(Context.NOTIFICATION_SERVICE);

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            NotificationChannel channel = new NotificationChannel("WordofthedayChannel", "Word of the day", NotificationManager.IMPORTANCE_DEFAULT);
            notificationManager.createNotificationChannel(channel);
        }

        // Get a random word and its definition
        Map<String, String> words = WordsUtil.WORDS;
        List<String> keys = new ArrayList<>(words.keySet());
        Random random = new Random();
        String word = keys.get(random.nextInt(keys.size()));
        String definition = words.get(word);

        // Build the notification
        NotificationCompat.Builder builder = new NotificationCompat.Builder(context, "WordofthedayChannel")
                .setSmallIcon(R.mipmap.logo)
                .setContentTitle("Word of the day: " + word)
                .setContentText(definition)
                .setPriority(NotificationCompat.PRIORITY_DEFAULT);

        notificationManager.notify(1, builder.build());
    }
}