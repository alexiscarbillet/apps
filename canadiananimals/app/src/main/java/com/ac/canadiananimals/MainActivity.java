package com.ac.canadiananimals;

import android.content.Intent;
import android.os.Bundle;
import android.widget.Button;

import androidx.appcompat.app.AppCompatActivity;

public class MainActivity extends AppCompatActivity {

    Button btnBirds, btnFishes, btnMammals;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

        findViewById(R.id.btnBirds).setOnClickListener(v -> openCategory("bird"));
        findViewById(R.id.btnFishes).setOnClickListener(v -> openCategory("fish"));
        findViewById(R.id.btnMammals).setOnClickListener(v -> openCategory("mammal"));
    }

    private void openCategory(String category) {
        Intent intent = new Intent(this, AnimalListActivity.class);
        intent.putExtra("category", category);
        startActivity(intent);
    }

}
