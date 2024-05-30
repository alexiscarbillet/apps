package com.ac.wordoftheday;

import android.app.NotificationManager;
import android.app.PendingIntent;
import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import androidx.core.app.NotificationCompat;

import java.util.Random;

public class NotificationReceiver extends BroadcastReceiver {

    private static final String CHANNEL_ID = "word_of_the_day_channel";

    @Override
    public void onReceive(Context context, Intent intent) {
        // Get a random word from the list
        String[] wordsArray = WordsUtil.WORDS.keySet().toArray(new String[0]);
        Random random = new Random();
        String randomWord = wordsArray[random.nextInt(wordsArray.length)];
        String definition = WordsUtil.WORDS.get(randomWord);

        // Create the notification
        NotificationCompat.Builder builder = new NotificationCompat.Builder(context, CHANNEL_ID)
                .setSmallIcon(R.mipmap.logo) // Replace with your app's icon
                .setContentTitle("Word of the Day")
                .setContentText(randomWord + ": " + definition)
                .setPriority(NotificationCompat.PRIORITY_DEFAULT);

        // Create an intent that will open the app when the notification is tapped
        Intent resultIntent = new Intent(context, MainActivity.class);
        PendingIntent resultPendingIntent = PendingIntent.getActivity(context, 0, resultIntent, PendingIntent.FLAG_UPDATE_CURRENT | PendingIntent.FLAG_IMMUTABLE);
        builder.setContentIntent(resultPendingIntent);

        // Show the notification
        NotificationManager notificationManager = (NotificationManager) context.getSystemService(Context.NOTIFICATION_SERVICE);
        if (notificationManager != null) {
            notificationManager.notify(0, builder.build());
        }
    }
}
