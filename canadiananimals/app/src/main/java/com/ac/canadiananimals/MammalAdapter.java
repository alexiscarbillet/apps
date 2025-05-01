package com.ac.canadiananimals;

import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;
import android.widget.TextView;

import androidx.annotation.NonNull;
import androidx.recyclerview.widget.RecyclerView;

import java.util.List;

public class MammalAdapter extends RecyclerView.Adapter<MammalAdapter.MammalViewHolder> {

    public interface OnItemClickListener {
        void onItemClick(Mammal mammal);
    }

    private List<Mammal> mammalList;
    private OnItemClickListener listener;

    public MammalAdapter(List<Mammal> mammalList, OnItemClickListener listener) {
        this.mammalList = mammalList;
        this.listener = listener;
    }

    @NonNull
    @Override
    public MammalViewHolder onCreateViewHolder(@NonNull ViewGroup parent, int viewType) {
        View view = LayoutInflater.from(parent.getContext()).inflate(R.layout.item_animal, parent, false);
        return new MammalViewHolder(view);
    }

    @Override
    public void onBindViewHolder(@NonNull MammalViewHolder holder, int position) {
        Mammal mammal = mammalList.get(position);
        holder.bind(mammal, listener);
    }

    @Override
    public int getItemCount() {
        return mammalList.size();
    }

    static class MammalViewHolder extends RecyclerView.ViewHolder {
        ImageView image;
        TextView name;

        MammalViewHolder(View itemView) {
            super(itemView);
            image = itemView.findViewById(R.id.itemImage);
            name = itemView.findViewById(R.id.itemName);
        }

        void bind(final Mammal mammal, final OnItemClickListener listener) {
            image.setImageResource(mammal.getImageResourceId());
            name.setText(mammal.getName());
            itemView.setOnClickListener(v -> listener.onItemClick(mammal));
        }
    }
}
