package com.app.canadianbirds;

import android.content.Intent;
import android.os.Bundle;

import androidx.appcompat.app.AppCompatActivity;
import androidx.recyclerview.widget.LinearLayoutManager;
import androidx.recyclerview.widget.RecyclerView;

import java.util.ArrayList;
import java.util.List;

public class MainActivity extends AppCompatActivity implements BirdAdapter.OnItemClickListener {

    private RecyclerView recyclerView;
    private BirdAdapter birdAdapter;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

        // Sample bird data
        List<Bird> birdList = getBirdList();

        // Initialize RecyclerView and adapter
        recyclerView = findViewById(R.id.recyclerView);
        birdAdapter = new BirdAdapter(birdList, this);

        // Set up RecyclerView layout manager and adapter
        recyclerView.setLayoutManager(new LinearLayoutManager(this));
        recyclerView.setAdapter(birdAdapter);
    }

    @Override
    public void onItemClick(Bird bird) {
        // Handle item click, start BirdDetailActivity and pass data
        Intent intent = new Intent(this, BirdDetailActivity.class);
        intent.putExtra("birdName", bird.getName());
        intent.putExtra("birdImageResourceId", bird.getImageResourceId());
        intent.putExtra("birdDescription", bird.getDescription());
        intent.putExtra("birdLength", bird.getLength());
        intent.putExtra("birdWeight", bird.getWeight());
        intent.putExtra("birdWingspan", bird.getWingspan());
        startActivity(intent);
    }

    private List<Bird> getBirdList() {
        List<Bird> birds = new ArrayList<>();
        birds.add(new Bird("Canada Goose", R.drawable.canadian_goose, "Canada Goose (Branta canadensis): These large waterfowl are easily recognizable with their distinctive black neck and head and white cheek patches.", "29.9-43.3 in (76-110 cm)","105.8-317.5 oz (3000-9000 g)","50.0-66.9 in (127-170 cm)"));
        birds.add(new Bird("Mallard", R.drawable.mallard, "Mallard (Anas platyrhynchos): The Mallard is a common and adaptable duck found in various aquatic habitats across Canada.", "19.7-25.6 in (50-65 cm)", "35.3-45.9 oz (1000-1300 g)", "32.3-37.4 in (82-95 cm)"));
        birds.add(new Bird("Common Loon", R.drawable.common_loon, "Common Loon (Gavia immer): Known for their haunting calls, loons are often associated with northern lakes. They are the provincial bird of Ontario.", "26.0-35.8 in (66-91 cm)", "88.2-215.2 oz (2500-6100 g)", "40.9-51.6 in (104-131 cm)"));
        birds.add(new Bird("American Robin", R.drawable.american_robin, "American Robin (Turdus migratorius): Recognizable by their red breast, American Robins are widespread across Canada and are often associated with suburban and urban areas.", "7.9-11.0 in (20-28 cm)", "2.7-3.0 oz (77-85 g)", "12.2-15.8 in (31-40 cm)"));
        birds.add(new Bird("Black-capped Chickadee", R.drawable.black_capped_chickadee, "Black-capped Chickadee (Poecile atricapillus): These small, energetic birds with distinctive black caps and bibs are common in forests and suburban areas.", "4.7-5.9 in (12-15 cm)", "0.3-0.5 oz (9-14 g)", "6.3-8.3 in (16-21 cm)"));
        birds.add(new Bird("Red-winged Blackbird", R.drawable.red_winged_blackbird, "Red-winged Blackbird (Agelaius phoeniceus): The males are easily identified by their red and yellow shoulder patches. They are often found near wetlands and marshes.", "6.7-9.1 in (17-23 cm)", "1.1-2.7 oz (32-77 g)", "12.2-15.8 in (31-40 cm)"));
        birds.add(new Bird("Northern Cardinal", R.drawable.northern_cardinal, "Northern Cardinal (Cardinalis cardinalis): Though more common in the eastern parts of Canada, Northern Cardinals are becoming increasingly prevalent in urban areas.", "8.3-9.1 in (21-23 cm)", "1.5-1.7 oz (42-48 g)", "9.8-12.2 in (25-31 cm)"));
        birds.add(new Bird("Blue Jay", R.drawable.blue_jay, "Blue Jay (Cyanocitta cristata): Blue Jays are known for their striking blue plumage and are common in both urban and forested areas.", "9.8-11.8 in (25-30 cm)", "2.5-3.5 oz (70-100 g)", "13.4-16.9 in (34-43 cm)"));
        birds.add(new Bird("Rock Pigeon", R.drawable.rock_pigeon, "Rock Pigeon (Columba livia): Also known as city pigeons, they are found in urban areas throughout Canada.", "11.8-14.2 in (30-36 cm)", "9.3-13.4 oz (265-380 g)", "19.7-26.4 in (50-67 cm)"));
        birds.add(new Bird("House Sparrow", R.drawable.house_sparrow, "House Sparrow (Passer domesticus): Introduced from Europe, House Sparrows are now widespread in urban and suburban environments.", "5.9-6.7 in (15-17 cm)", "0.9-1.1 oz (27-30 g)", "7.5-9.8 in (19-25 cm)"));
        // Add more birds as needed
        return birds;
    }
}
