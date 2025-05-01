package com.ac.canadiananimals;

import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;
import android.widget.TextView;

import androidx.annotation.NonNull;
import androidx.recyclerview.widget.RecyclerView;

import java.util.List;

public class FishAdapter extends RecyclerView.Adapter<FishAdapter.FishViewHolder> {

    public interface OnItemClickListener {
        void onItemClick(Fish fish);
    }

    private List<Fish> fishList;
    private OnItemClickListener listener;

    public FishAdapter(List<Fish> fishList, OnItemClickListener listener) {
        this.fishList = fishList;
        this.listener = listener;
    }

    @NonNull
    @Override
    public FishViewHolder onCreateViewHolder(@NonNull ViewGroup parent, int viewType) {
        View view = LayoutInflater.from(parent.getContext()).inflate(R.layout.item_animal, parent, false);
        return new FishViewHolder(view);
    }

    @Override
    public void onBindViewHolder(@NonNull FishViewHolder holder, int position) {
        Fish fish = fishList.get(position);
        holder.bind(fish, listener);
    }

    @Override
    public int getItemCount() {
        return fishList.size();
    }

    static class FishViewHolder extends RecyclerView.ViewHolder {
        ImageView image;
        TextView name;

        FishViewHolder(View itemView) {
            super(itemView);
            image = itemView.findViewById(R.id.itemImage);
            name = itemView.findViewById(R.id.itemName);
        }

        void bind(final Fish fish, final OnItemClickListener listener) {
            image.setImageResource(fish.getImageResourceId());
            name.setText(fish.getName());
            itemView.setOnClickListener(v -> listener.onItemClick(fish));
        }
    }
}
