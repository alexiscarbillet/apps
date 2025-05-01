package com.ac.canadiananimals;

import java.util.ArrayList;
import java.util.List;

public class FishDataProvider {

    public List<Fish> getFishList() {
        List<Fish> fish = new ArrayList<>();
        fish.add(new Fish("Northern Pike", R.drawable.northern_pike, "A predatory fish found in freshwater lakes and rivers.", "16–22 in (40–55 cm)", "2–10 lb (0.9–4.5 kg)"));
        fish.add(new Fish("Lake Trout", R.drawable.lake_trout, "Deep, cold lakes of Canada are home to this prized sport fish.", "20–30 in (50–76 cm)", "5–15 lb (2.3–6.8 kg)"));
        fish.add(new Fish("Brook Trout", R.drawable.brook_trout, "Common in clear, cold streams and small lakes across Canada.", "10–16 in (25–41 cm)", "1–3 lb (0.5–1.4 kg)"));
        fish.add(new Fish("Arctic Char", R.drawable.arctic_char, "Found in northern lakes and rivers; closely related to trout and salmon.", "20–25 in (50–63 cm)", "4–10 lb (1.8–4.5 kg)"));
        fish.add(new Fish("Atlantic Salmon", R.drawable.atlantic_salmon, "Anadromous fish once widespread in eastern Canada.", "28–30 in (71–76 cm)", "8–12 lb (3.6–5.4 kg)"));
        fish.add(new Fish("Walleye", R.drawable.walleye, "Popular sport fish found in many Canadian lakes.", "15–25 in (38–63 cm)", "2–6 lb (0.9–2.7 kg)"));
        fish.add(new Fish("Yellow Perch", R.drawable.yellow_perch, "Common panfish in central and eastern Canadian waters.", "5–12 in (13–30 cm)", "0.5–1 lb (0.2–0.5 kg)"));
        fish.add(new Fish("Lake Whitefish", R.drawable.lake_whitefish, "Cold-water fish prized for its delicate flavor.", "12–25 in (30–63 cm)", "2–5 lb (0.9–2.3 kg)"));
        fish.add(new Fish("Burbot", R.drawable.burbot, "A cold-water bottom dweller resembling a freshwater cod.", "18–30 in (46–76 cm)", "2–6 lb (0.9–2.7 kg)"));
        fish.add(new Fish("Sturgeon", R.drawable.sturgeon, "Ancient, long-lived fish found in rivers like the Fraser and St. Lawrence.", "30–72 in (76–183 cm)", "20–100+ lb (9–45+ kg)"));
        return fish;
    }
}
