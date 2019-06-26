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

function dfs_link(tree, n1, parent, n2) {
    if(tree.id == n1.id){
        if(n2 == null)
            return tree;
        for(var i = 0; i < parent.children.length; i++){
            if(parent.children[i].id == tree.id)
                parent.children.splice(i, 1);
        }
        if(!('children' in n2))
            n2.children = [];
        n2.children.push(tree);
        return true;
    }
    else if('children' in tree){
        for(var i = 0; i < tree.children.length; i++){
            var result = dfs_link(tree.children[i], n1, tree, n2);
            if (result != false)
                return result;
        }
    }
    return false;
}

function update_data() {
    root = d3.hierarchy(root.data, function(d) { return d.children; });
    root.x0 = width / 2;
    root.y0 = height;
    console.log(root);
    root.children.forEach(collapse);
    update(root);
}