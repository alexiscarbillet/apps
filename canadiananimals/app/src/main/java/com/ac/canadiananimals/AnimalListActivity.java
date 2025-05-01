package com.ac.canadiananimals;

import android.content.Intent;
import android.os.Bundle;
import android.widget.Toast;

import androidx.appcompat.app.AppCompatActivity;
import androidx.recyclerview.widget.LinearLayoutManager;
import androidx.recyclerview.widget.RecyclerView;

import java.util.List;

public class AnimalListActivity extends AppCompatActivity implements
        BirdAdapter.OnItemClickListener,
        FishAdapter.OnItemClickListener,
        MammalAdapter.OnItemClickListener {

    private RecyclerView recyclerView;
    private String category;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_animal_list);

        recyclerView = findViewById(R.id.recyclerView);
        recyclerView.setLayoutManager(new LinearLayoutManager(this));

        // Get the category from the intent
        category = getIntent().getStringExtra("category");

        // Use the category to load the appropriate data and adapter
        switch (category) {
            case "bird":
                // Get bird list and set the BirdAdapter
                BirdDataProvider birdDataProvider = new BirdDataProvider();
                List<Bird> birds = birdDataProvider.getBirdList();
                BirdAdapter birdAdapter = new BirdAdapter(birds, this);
                recyclerView.setAdapter(birdAdapter);
                break;

            case "fish":
                // Get fish list and set the FishAdapter
                FishDataProvider fishDataProvider = new FishDataProvider();
                List<Fish> fishes = fishDataProvider.getFishList();
                FishAdapter fishAdapter = new FishAdapter(fishes, this);
                recyclerView.setAdapter(fishAdapter);
                break;

            case "mammal":
                // Get mammal list and set the MammalAdapter
                MammalDataProvider mammalDataProvider = new MammalDataProvider();
                List<Mammal> mammals = mammalDataProvider.getMammalList();
                MammalAdapter mammalAdapter = new MammalAdapter(mammals, this);
                recyclerView.setAdapter(mammalAdapter);
                break;

            default:
                // Handle case where category is not recognized (optional)
                Toast.makeText(this, "Invalid category", Toast.LENGTH_SHORT).show();
                break;
        }
    }

    // Call respective detail activity or toast
    @Override
    public void onItemClick(Bird bird) {
        Intent intent = new Intent(this, BirdDetailActivity.class);
        intent.putExtra("birdName", bird.getName());
        intent.putExtra("birdImageResourceId", bird.getImageResourceId());
        intent.putExtra("birdDescription", bird.getDescription());
        intent.putExtra("birdLength", bird.getLength());
        intent.putExtra("birdWeight", bird.getWeight());
        intent.putExtra("birdWingspan", bird.getWingspan());
        startActivity(intent);
    }

    @Override
    public void onItemClick(Fish fish) {
        Intent intent = new Intent(this, FishDetailActivity.class);
        intent.putExtra("fishName", fish.getName());
        intent.putExtra("fishImageResourceId", fish.getImageResourceId());
        intent.putExtra("fishDescription", fish.getDescription());
        intent.putExtra("fishLength", fish.getLength());
        intent.putExtra("fishWeight", fish.getWeight());
        startActivity(intent);
    }

    @Override
    public void onItemClick(Mammal mammal) {
        Intent intent = new Intent(this, MammalDetailActivity.class);
        intent.putExtra("mammalName", mammal.getName());
        intent.putExtra("mammalImageResourceId", mammal.getImageResourceId());
        intent.putExtra("mammalDescription", mammal.getDescription());
        intent.putExtra("mammalLength", mammal.getLength());
        intent.putExtra("mammalWeight", mammal.getWeight());
        startActivity(intent);
    }

}
