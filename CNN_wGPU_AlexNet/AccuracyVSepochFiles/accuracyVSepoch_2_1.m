prunemode = 2
imdsTest  = imageDatastore('/data/tibrayev/imagenet2012_zeromeanNormalized/val', 'IncludeSubFolders', true, 'LabelSource', 'foldernames');
for e = 111:120
    fprintf(['epoch:' num2str(e) '\n'])
    Directory = dir(sprintf('./checkpoints/prunemode%d/epoch%d/', prunemode, e));
    FileName = Directory(3).name
    try
        load(sprintf('./checkpoints/prunemode%d/epoch%d/%s',prunemode,e,FileName))
        predictedLabels = classify(net, imdsTest, ...
        'MiniBatchSize', 30, ...
        'ExecutionEnvironment', 'gpu');
        accuracy_prunemode2(e,:) = sum(predictedLabels == imdsTest.Labels)/numel(imdsTest.Labels)*100;
        accuracy_prunemode2(end,:)
    catch
        disp('no checkpoint file found!')
    end
    clear net
end
save([sprintf('accuracyVSepochs_prunemode%d', prunemode) '.mat'], 'accuracy_prunemode2') 