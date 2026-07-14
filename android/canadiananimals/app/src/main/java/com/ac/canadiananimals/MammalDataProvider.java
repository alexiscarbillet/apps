package com.ac.canadiananimals;

import java.util.ArrayList;
import java.util.List;

public class MammalDataProvider {
    public List<Mammal> getMammalList() {
        List<Mammal> mammals = new ArrayList<>();
        mammals.add(new Mammal("Moose", R.drawable.moose, "Largest member of the deer family; found across Canada.", "6–7 ft (1.8–2.1 m)", "800–1500 lb (360–680 kg)"));
        mammals.add(new Mammal("Beaver", R.drawable.beaver, "Canada's national animal; known for dam-building.", "2.3–3.3 ft (0.7–1 m)", "35–70 lb (16–32 kg)"));
        mammals.add(new Mammal("Grizzly Bear", R.drawable.grizzly_bear, "Large bear found in western Canada and the Rockies.", "6.5–8 ft (2–2.5 m)", "400–790 lb (180–360 kg)"));
        mammals.add(new Mammal("Black Bear", R.drawable.black_bear, "Common bear species in most Canadian provinces.", "4–6 ft (1.2–1.8 m)", "200–600 lb (90–270 kg)"));
        mammals.add(new Mammal("Canada Lynx", R.drawable.canada_lynx, "Elusive wild cat with tufted ears, found in forests.", "2.5–3.5 ft (0.75–1.1 m)", "18–24 lb (8–11 kg)"));
        mammals.add(new Mammal("White-tailed Deer", R.drawable.white_tailed_deer, "Widespread deer species across southern Canada.", "5–7 ft (1.5–2.1 m)", "100–300 lb (45–135 kg)"));
        mammals.add(new Mammal("Caribou", R.drawable.caribou, "Also called reindeer; known for long migrations.", "4.5–6.5 ft (1.4–2 m)", "180–400 lb (82–181 kg)"));
        mammals.add(new Mammal("Wolverine", R.drawable.wolverine, "Strong, solitary animal found in remote northern areas.", "3–3.5 ft (0.9–1.1 m)", "20–55 lb (9–25 kg)"));
        mammals.add(new Mammal("Bison", R.drawable.bison, "Massive grazers historically found across Canadian plains.", "7–11.5 ft (2.1–3.5 m)", "900–2200 lb (400–1000 kg)"));
        mammals.add(new Mammal("Arctic Fox", R.drawable.arctic_fox, "Adapted to cold tundra; has white winter fur.", "18–27 in (46–69 cm)", "6–10 lb (2.7–4.5 kg)"));
        return mammals;
    }
}
