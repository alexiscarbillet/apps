package com.ac.motdujour;

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

import android.os.Bundle;
import android.widget.TextView;
import androidx.appcompat.app.AppCompatActivity;
import androidx.work.PeriodicWorkRequest;
import androidx.work.WorkManager;
import androidx.work.WorkRequest;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.Random;
import java.util.concurrent.TimeUnit;

public class MainActivity extends AppCompatActivity {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

        // Schedule the daily notification
        WorkRequest dailyWorkRequest = new PeriodicWorkRequest.Builder(NotificationWorker.class, 24, TimeUnit.HOURS)
                .build();
        WorkManager.getInstance(this).enqueue(dailyWorkRequest);

        // Get a random word and its definition
        Map<String, String> words = WordsUtil.WORDS;
        List<String> keys = new ArrayList<>(words.keySet());
        Random random = new Random();
        String word = keys.get(random.nextInt(keys.size()));
        String definition = words.get(word);

        // Display the word and its definition
        TextView wordTextView = findViewById(R.id.wordTextView);
        TextView definitionTextView = findViewById(R.id.definitionTextView);
        wordTextView.setText(word);
        definitionTextView.setText(definition);
    }
}
