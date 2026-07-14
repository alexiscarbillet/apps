package com.ac.canadiananimals;

import android.os.Bundle;
import android.widget.ImageView;
import android.widget.TextView;

import androidx.appcompat.app.AppCompatActivity;

public class MammalDetailActivity extends AppCompatActivity {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_mammal_detail);

        ImageView imageView = findViewById(R.id.mammalImage);
        TextView nameView = findViewById(R.id.mammalName);
        TextView descView = findViewById(R.id.mammalDescription);
        TextView lengthView = findViewById(R.id.mammalLength);
        TextView weightView = findViewById(R.id.mammalWeight);

        // Get intent extras
        String name = getIntent().getStringExtra("mammalName");
        String description = getIntent().getStringExtra("mammalDescription");
        String length = getIntent().getStringExtra("mammalLength");
        String weight = getIntent().getStringExtra("mammalWeight");
        int imageResId = getIntent().getIntExtra("mammalImageResourceId", R.drawable.ic_launcher_background);

        // Set UI
        imageView.setImageResource(imageResId);
        nameView.setText(name);
        descView.setText(description);
        lengthView.setText("Length: " + length);
        weightView.setText("Weight: " + weight);
    }
}
