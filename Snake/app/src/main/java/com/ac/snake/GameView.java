package com.ac.snake;

import android.content.Context;
import android.graphics.Canvas;
import android.graphics.Color;
import android.graphics.Paint;
import android.util.AttributeSet;
import android.view.SurfaceHolder;
import android.view.SurfaceView;

import java.util.ArrayList;
import java.util.List;
import java.util.Random;

public class GameView extends SurfaceView implements Runnable {
    private Thread thread;
    private boolean isPlaying;
    private Paint paint;
    private SurfaceHolder surfaceHolder;
    private List<int[]> snake;
    private int[] food;
    private int direction = 1; // 0 = up, 1 = right, 2 = down, 3 = left
    private int score = 0;

    public GameView(Context context, AttributeSet attrs) {
        super(context, attrs);
        surfaceHolder = getHolder();
        paint = new Paint();
        snake = new ArrayList<>();
        snake.add(new int[]{5, 5}); // Initial position
        generateFood();
    }

    @Override
    public void run() {
        while (isPlaying) {
            update();
            draw();
            sleep();
        }
    }

    private void update() {
        // Move snake
        int[] head = snake.get(0);
        int newHeadX = head[0];
        int newHeadY = head[1];

        switch (direction) {
            case 0:
                newHeadY--;
                break;
            case 1:
                newHeadX++;
                break;
            case 2:
                newHeadY++;
                break;
            case 3:
                newHeadX--;
                break;
        }

        int[] newHead = {newHeadX, newHeadY};
        snake.add(0, newHead);

        // Check if the snake eats the food
        if (newHeadX == food[0] && newHeadY == food[1]) {
            score++;
            generateFood();
        } else {
            snake.remove(snake.size() - 1); // Remove the tail
        }

        // Check for collision with the wall
        if (newHeadX < 0 || newHeadY < 0 || newHeadX >= 20 || newHeadY >= 20) {
            isPlaying = false;
        }

        // Check for collision with itself
        for (int i = 1; i < snake.size(); i++) {
            if (snake.get(i)[0] == newHeadX && snake.get(i)[1] == newHeadY) {
                isPlaying = false;
            }
        }
    }

    private void generateFood() {
        Random random = new Random();
        food = new int[]{random.nextInt(20), random.nextInt(20)};
    }

    private void draw() {
        if (surfaceHolder.getSurface().isValid()) {
            Canvas canvas = surfaceHolder.lockCanvas();
            canvas.drawColor(Color.BLACK);
            paint.setColor(Color.GREEN);
            for (int[] pos : snake) {
                canvas.drawRect(pos[0] * 50, pos[1] * 50, (pos[0] + 1) * 50, (pos[1] + 1) * 50, paint);
            }
            paint.setColor(Color.RED);
            canvas.drawRect(food[0] * 50, food[1] * 50, (food[0] + 1) * 50, (food[1] + 1) * 50, paint);
            surfaceHolder.unlockCanvasAndPost(canvas);
        }
    }

    private void sleep() {
        try {
            Thread.sleep(300);
        } catch (InterruptedException e) {
            e.printStackTrace();
        }
    }

    public void resume() {
        isPlaying = true;
        thread = new Thread(this);
        thread.start();
    }

    public void pause() {
        try {
            isPlaying = false;
            thread.join();
        } catch (InterruptedException e) {
            e.printStackTrace();
        }
    }

    public void setDirection(int direction) {
        this.direction = direction;
    }
}

