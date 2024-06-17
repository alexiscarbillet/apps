package com.ac.canadatrees;

import android.content.Intent;
import android.os.Bundle;

import androidx.appcompat.app.AppCompatActivity;
import androidx.recyclerview.widget.LinearLayoutManager;
import androidx.recyclerview.widget.RecyclerView;

import java.util.ArrayList;
import java.util.List;

public class MainActivity extends AppCompatActivity implements TreeAdapter.OnItemClickListener {

    private RecyclerView recyclerView;
    private TreeAdapter treeAdapter;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

        // Sample tree data
        List<Tree> treeList = getTreeList();

        // Initialize RecyclerView and adapter
        recyclerView = findViewById(R.id.recyclerView);
        treeAdapter = new TreeAdapter(treeList, this);

        // Set up RecyclerView layout manager and adapter
        recyclerView.setLayoutManager(new LinearLayoutManager(this));
        recyclerView.setAdapter(treeAdapter);
    }

    @Override
    public void onItemClick(Tree tree) {
        // Handle item click, start TreeDetailActivity and pass data
        Intent intent = new Intent(this, TreeDetailActivity.class);
        intent.putExtra("treeName", tree.getName());
        intent.putExtra("treeImageResourceId", tree.getImageResourceId());
        intent.putExtra("treeDescription", tree.getDescription());
        intent.putExtra("treeHeight", tree.getHeight());
        intent.putExtra("treeBark", tree.getBark());
        intent.putExtra("treeLeaves", tree.getLeaves());
        startActivity(intent);
    }

    private List<Tree> getTreeList() {
        List<Tree> trees = new ArrayList<>();
        trees.add(new Tree("White Spruce", R.drawable.white_spruce, "White Spruce (Picea glauca): The needles have a fresh, pleasant aroma when crushed.", "50-100 ft", "Grayish-brown, scaly", "Needles are sharp, square in cross-section"));
        trees.add(new Tree("Black Spruce", R.drawable.black_spruce, "Black Spruce (Picea mariana): Often grows in sphagnum bogs and cold, wet areas.", "20-50 ft", "Dark, scaly", "Needles are short and stiff"));
        trees.add(new Tree("Red Spruce", R.drawable.red_spruce, "Red Spruce (Picea rubens): The wood is valued for making musical instruments.", "60-80 ft", "Reddish-brown, scaly", "Needles are yellow-green, shiny"));
        trees.add(new Tree("Balsam Fir", R.drawable.balsam_fir, "Balsam Fir (Abies balsamea): Needles are flat and soft, exuding a strong fragrance.", "45-75 ft", "Smooth, grayish", "Needles are flat, shiny dark green"));
        trees.add(new Tree("Eastern White Pine", R.drawable.eastern_white_pine, "Eastern White Pine (Pinus strobus): Long, slender needles in clusters of five.", "80-110 ft", "Grayish-brown, fissured", "Needles are soft, flexible"));
        trees.add(new Tree("Jack Pine", R.drawable.jack_pine, "Jack Pine (Pinus banksiana): Cones require fire to open and release seeds.", "30-70 ft", "Reddish-brown, irregular", "Needles are twisted, in pairs"));
        trees.add(new Tree("Lodgepole Pine", R.drawable.lodgepole_pine, "Lodgepole Pine (Pinus contorta): Unique, contorted growth pattern.", "70-80 ft", "Thin, scaly", "Needles are yellow-green, in pairs"));
        trees.add(new Tree("Sugar Maple", R.drawable.sugar_maple, "Sugar Maple (Acer saccharum): Primary source of maple syrup.", "60-75 ft", "Grayish-brown, furrowed", "Leaves are lobed with five points"));
        trees.add(new Tree("Red Maple", R.drawable.red_maple, "Red Maple (Acer rubrum): Highly adaptable to various soil types.", "40-60 ft", "Gray, smooth when young", "Leaves are lobed with serrated edges"));
        trees.add(new Tree("Silver Maple", R.drawable.silver_maple, "Silver Maple (Acer saccharinum): Leaves have silvery white undersides.", "50-80 ft", "Grayish-brown, shaggy", "Leaves are deeply lobed"));
        trees.add(new Tree("Paper Birch", R.drawable.paper_birch, "Paper Birch (Betula papyrifera): White bark peels in thin, papery layers.", "50-70 ft", "White, peeling", "Leaves are ovate, toothed edges"));
        trees.add(new Tree("Yellow Birch", R.drawable.yellow_birch, "Yellow Birch (Betula alleghaniensis): Bark is yellow-bronze and shiny.", "60-75 ft", "Yellowish-bronze, peeling", "Leaves are oval, finely serrated"));
        trees.add(new Tree("American Beech", R.drawable.american_beech, "American Beech (Fagus grandifolia): Smooth, gray bark remains unmarked.", "50-70 ft", "Smooth, gray", "Leaves are ovate, with straight veins"));
        trees.add(new Tree("Eastern White Cedar", R.drawable.eastern_white_cedar, "Eastern White Cedar (Thuja occidentalis): Scale-like leaves and aromatic wood.", "40-60 ft", "Reddish-brown, fibrous", "Leaves are scale-like, arranged in flat sprays"));
        trees.add(new Tree("Douglas Fir", R.drawable.douglas_fir, "Douglas Fir (Pseudotsuga menziesii): Cones have unique three-pointed bracts.", "70-330 ft", "Thick, rough", "Needles are flat, soft"));
        trees.add(new Tree("Western Red Cedar", R.drawable.western_red_cedar, "Western Red Cedar (Thuja plicata): Naturally rot-resistant wood.", "50-200 ft", "Reddish-brown, fibrous", "Leaves are scale-like, aromatic"));
        // Add more trees as needed
        return trees;
    }
}
