package com.ac.SpanSheets;

import android.content.Intent;
import android.os.Bundle;
import android.view.View;
import android.widget.Button;

import androidx.appcompat.app.AppCompatActivity;

public class MainMenuActivity extends AppCompatActivity {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main_menu);

        Button btnWyrmspan = findViewById(R.id.btnWyrmspan);
        Button btnWingspan = findViewById(R.id.btnWingspan);
        Button btnFinspan = findViewById(R.id.btnFinspan);

        btnWyrmspan.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                // Navigate to Wyrmspan
                Intent intent = new Intent(MainMenuActivity.this, WyrmspanMainActivity.class);
                startActivity(intent);
            }
        });

        btnWingspan.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                // Navigate to Wingspan
                Intent intent = new Intent(MainMenuActivity.this, WingspanMainActivity.class);
                startActivity(intent);
            }
        });

        btnFinspan.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                // Navigate to Finspan
                Intent intent = new Intent(MainMenuActivity.this, FinspanMainActivity.class);
                startActivity(intent);
            }
        });
    }
}
