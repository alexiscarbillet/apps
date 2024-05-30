package com.ac.wordoftheday;

import android.app.AlarmManager;
import android.app.NotificationChannel;
import android.app.NotificationManager;
import android.app.PendingIntent;
import android.content.Context;
import android.content.Intent;
import android.os.Build;
import android.os.Bundle;
import android.widget.TextView;
import androidx.appcompat.app.AppCompatActivity;
import androidx.core.app.NotificationCompat;

import java.util.Calendar;
import java.util.Random;

public class MainActivity extends AppCompatActivity {

    private static final String CHANNEL_ID = "word_of_the_day_channel";
    private TextView wordTextView;
    private TextView definitionTextView;
    private TextView messageTextView;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

        wordTextView = findViewById(R.id.wordTextView);
        definitionTextView = findViewById(R.id.definitionTextView);
        messageTextView = findViewById(R.id.messageTextView);

        // Get a random word from the list
        String[] wordsArray = WordsUtil.WORDS.keySet().toArray(new String[0]);
        Random random = new Random();
        String randomWord = wordsArray[random.nextInt(wordsArray.length)];
        String definition = WordsUtil.WORDS.get(randomWord);

        // Set the word and definition in the TextViews
        wordTextView.setText(randomWord);
        definitionTextView.setText(definition);

        // Create a notification channel
        createNotificationChannel();

        // Schedule the daily notification
        scheduleDailyNotification();
    }

    private void createNotificationChannel() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            CharSequence name = "Word of the Day Channel";
            String description = "Channel for Word of the Day notifications";
            int importance = NotificationManager.IMPORTANCE_DEFAULT;
            NotificationChannel channel = new NotificationChannel(CHANNEL_ID, name, importance);
            channel.setDescription(description);
            NotificationManager notificationManager = getSystemService(NotificationManager.class);
            notificationManager.createNotificationChannel(channel);
        }
    }

    private void scheduleDailyNotification() {
        Intent intent = new Intent(this, NotificationReceiver.class);
        PendingIntent pendingIntent = PendingIntent.getBroadcast(this, 0, intent, PendingIntent.FLAG_UPDATE_CURRENT | PendingIntent.FLAG_IMMUTABLE);

        AlarmManager alarmManager = (AlarmManager) getSystemService(Context.ALARM_SERVICE);
        Calendar calendar = Calendar.getInstance();
        calendar.setTimeInMillis(System.currentTimeMillis());
        calendar.set(Calendar.HOUR_OF_DAY, 9); // Set the notification time to 9 AM
        calendar.set(Calendar.MINUTE, 0);
        calendar.set(Calendar.SECOND, 0);

        if (alarmManager != null) {
            alarmManager.setInexactRepeating(AlarmManager.RTC_WAKEUP, calendar.getTimeInMillis(), AlarmManager.INTERVAL_DAY, pendingIntent);
        }
    }
}

