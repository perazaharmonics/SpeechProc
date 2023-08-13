function y_denoised = fNLM_denoise(y, search_window, patch_size, h)
% ##########################################################################################################################################
% 
% Non-Local Means (NLM) denoising is a popular image denoising algorithm that can also be applied to one-dimensional signals like audio. 
% The NLM denoising method is based on the principle that similar patches in the signal should have similar denoised values. 
% By averaging similar patches, the method can effectively reduce noise while preserving signal structures
% 
% ###########################################################################################################################################
N = length(y);
y_denoised = zeros(size(y));

for i = 1:N
    start_search = max(1, i - search_window);
    end_search = min(N, i + search_window);
    search_indices = start_search:end_search;
    weights = zeros(size(search_indices));
    
    for j = 1:length(search_indices)
        start_patch_i = max(1, i - patch_size);
        end_patch_i = min(N, i + patch_size);
        
        start_patch_j = max(1, search_indices(j) - patch_size);
        end_patch_j = min(N, search_indices(j) + patch_size);
        
        patch_i = y(start_patch_i:end_patch_i);
        patch_j = y(start_patch_j:end_patch_j);
        
        d = min(length(patch_i), length(patch_j));
        
        squared_diff = (patch_i(1:d) - patch_j(1:d)).^2;
        distance = sum(squared_diff);
        
        weights(j) = exp(-distance / (h^2));
    end
    
    weights = weights / sum(weights);
    y_denoised(i) = sum(y(search_indices) .* weights);
end

end
