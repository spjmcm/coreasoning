function dfs_add_node(tree, source, target){
    if (tree.id == target){
        if(!('children' in tree))
            tree.children = [];
        tree.children.push({'id': source});
        return true;
    }
    else if ('children' in tree){
        for(var i = 0; i < tree.children.length; i++){
            var result = dfs_add_node(tree.children[i], source, target);
            if(result == true)
                return true;
        }
    }
    return false;
}

function dfs_replace_node_text(tree, changed_text, original_text){
    if (tree.id === original_text){
        tree.id = changed_text;
        return true;
    }
    else if ('children' in tree){
        for(var i = 0; i < tree.children.length; i++){
            var result = dfs_replace_node_text(tree.children[i], changed_text, original_text);
            if(result == true)
                return true;
        }
    }
    return false;
}



function update_data() {
    root = d3.hierarchy(root.data, function(d) { return d.children; });
    root.x0 = width / 2;
    root.y0 = height;
    root.children.forEach(collapse);
    update(root);
}