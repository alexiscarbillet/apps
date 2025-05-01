package com.ac.canadiananimals;

import android.os.Bundle;
import android.widget.ImageView;
import android.widget.TextView;

import androidx.appcompat.app.AppCompatActivity;

public class FishDetailActivity extends AppCompatActivity {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_fish_detail);

        ImageView imageView = findViewById(R.id.fishImage);
        TextView nameView = findViewById(R.id.fishName);
        TextView descView = findViewById(R.id.fishDescription);
        TextView lengthView = findViewById(R.id.fishLength);
        TextView weightView = findViewById(R.id.fishWeight);

        // Get intent extras
        String name = getIntent().getStringExtra("fishName");
        String description = getIntent().getStringExtra("fishDescription");
        String length = getIntent().getStringExtra("fishLength");
        String weight = getIntent().getStringExtra("fishWeight");
        int imageResId = getIntent().getIntExtra("fishImageResourceId", R.drawable.ic_launcher_background);

        // Set UI
        imageView.setImageResource(imageResId);
        nameView.setText(name);
        descView.setText(description);
        lengthView.setText("Length: " + length);
        weightView.setText("Weight: " + weight);
    }
}
