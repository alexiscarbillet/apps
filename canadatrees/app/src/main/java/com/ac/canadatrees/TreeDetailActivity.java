package com.ac.canadatrees;

import android.os.Bundle;
import android.widget.ImageView;
import android.widget.TextView;

import androidx.appcompat.app.AppCompatActivity;

public class TreeDetailActivity extends AppCompatActivity {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_tree_detail);

        // Get data from Intent
        String treeName = getIntent().getStringExtra("treeName");
        int treeImageResourceId = getIntent().getIntExtra("treeImageResourceId", 0);
        String treeDescription = getIntent().getStringExtra("treeDescription");
        String treeHeight = getIntent().getStringExtra("treeHeight");
        String treeBark = getIntent().getStringExtra("treeBark");
        String treeLeaves = getIntent().getStringExtra("treeLeaves");

        // Set data to views
        TextView nameTextView = findViewById(R.id.treeNameTextView);
        ImageView imageView = findViewById(R.id.treeImageView);
        TextView descriptionTextView = findViewById(R.id.treeDescriptionTextView);
        TextView heightTextView = findViewById(R.id.treeHeightTextView);
        TextView barkTextView = findViewById(R.id.treeBarkTextView);
        TextView leavesTextView = findViewById(R.id.treeLeavesTextView);

        nameTextView.setText(treeName);
        imageView.setImageResource(treeImageResourceId);
        descriptionTextView.setText(treeDescription);
        heightTextView.setText("Height: " + treeHeight);
        barkTextView.setText("Bark: " + treeBark);
        leavesTextView.setText("Leaves: " + treeLeaves);
    }
}
