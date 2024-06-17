package com.ac.canadatrees;

import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;
import android.widget.TextView;

import androidx.annotation.NonNull;
import androidx.recyclerview.widget.RecyclerView;

import java.util.List;

public class TreeAdapter extends RecyclerView.Adapter<TreeAdapter.TreeViewHolder> {

    private List<Tree> treeList;
    private OnItemClickListener listener;

    public interface OnItemClickListener {
        void onItemClick(Tree tree);
    }

    public TreeAdapter(List<Tree> treeList, OnItemClickListener listener) {
        this.treeList = treeList;
        this.listener = listener;
    }

    @NonNull
    @Override
    public TreeViewHolder onCreateViewHolder(@NonNull ViewGroup parent, int viewType) {
        View view = LayoutInflater.from(parent.getContext()).inflate(R.layout.tree_item, parent, false);
        return new TreeViewHolder(view);
    }

    @Override
    public void onBindViewHolder(@NonNull TreeViewHolder holder, int position) {
        Tree tree = treeList.get(position);
        holder.bind(tree, listener);
    }

    @Override
    public int getItemCount() {
        return treeList.size();
    }

    public static class TreeViewHolder extends RecyclerView.ViewHolder {

        private TextView nameTextView;
        private ImageView imageView;

        public TreeViewHolder(@NonNull View itemView) {
            super(itemView);
            nameTextView = itemView.findViewById(R.id.treeNameTextView);
            imageView = itemView.findViewById(R.id.treeImageView);
        }

        public void bind(final Tree tree, final OnItemClickListener listener) {
            nameTextView.setText(tree.getName());
            imageView.setImageResource(tree.getImageResourceId());
            itemView.setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View v) {
                    listener.onItemClick(tree);
                }
            });
        }
    }
}
