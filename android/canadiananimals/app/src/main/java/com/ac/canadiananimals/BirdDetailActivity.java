package com.ac.canadiananimals;

import android.content.Intent;
import android.os.Bundle;
import android.widget.ImageView;
import android.widget.TextView;

import androidx.appcompat.app.AppCompatActivity;

public class BirdDetailActivity extends AppCompatActivity {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_bird_detail);

        // Retrieve data from Intent
        Intent intent = getIntent();
        String birdName = intent.getStringExtra("birdName");
        int birdImageResourceId = intent.getIntExtra("birdImageResourceId", 0);
        String birdDescription = intent.getStringExtra("birdDescription");
        String birdLength = intent.getStringExtra("birdLength");
        String birdWeight = intent.getStringExtra("birdWeight");
        String birdWingspan = intent.getStringExtra("birdWingspan");

        // Update views with bird details
        ImageView birdImageView = findViewById(R.id.birdImage);
        TextView birdNameTextView = findViewById(R.id.birdName);
        TextView birdDescriptionTextView = findViewById(R.id.birdDescription);
        TextView birdLengthTextView = findViewById(R.id.birdLength);
        TextView birdWeightTextView = findViewById(R.id.birdWeight);
        TextView birdWingspanTextView = findViewById(R.id.birdWingspan);

        birdImageView.setImageResource(birdImageResourceId);
        birdNameTextView.setText(birdName);
        birdDescriptionTextView.setText(birdDescription);
        birdLengthTextView.setText("Length: " + birdLength);
        birdWeightTextView.setText("Weight: " + birdWeight);
        birdWingspanTextView.setText("Wingspan: " + birdWingspan);
    }

}
