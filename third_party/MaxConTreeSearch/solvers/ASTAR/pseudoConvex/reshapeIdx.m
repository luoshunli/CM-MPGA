function idxOut = reshapeIdx(idxIn, d)
    if size(idxIn,1)~=1
        idxIn = idxIn';
    end
    idxOut = reshape([idxIn*2;idxIn*2]-repmat((d-1:-1:0)',1,numel(idxIn)),1,d*numel(idxIn));
end