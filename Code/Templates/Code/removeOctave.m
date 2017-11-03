function x = removeOctave(a)

x = cell(size(a));
for i = 1:length(a)
    x{i} = a{i}(1:end-1);
end

end