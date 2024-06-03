package com.ac.snake;

import android.os.Bundle;
import android.view.View;
import androidx.appcompat.app.AppCompatActivity;

public class MainActivity extends AppCompatActivity {
    private GameView gameView;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);
        gameView = findViewById(R.id.gameView);
    }

    @Override
    protected void onPause() {
        super.onPause();
        gameView.pause();
    }

    @Override
    protected void onResume() {
        super.onResume();
        gameView.resume();
    }

    public void moveUp(View view) {
        gameView.setDirection(0);
    }

    public void moveRight(View view) {
        gameView.setDirection(1);
    }

    public void moveDown(View view) {
        gameView.setDirection(2);
    }

    public void moveLeft(View view) {
        gameView.setDirection(3);
    }
}

