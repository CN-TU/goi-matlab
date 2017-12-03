function clust_log( name, rclust, data, k, val )
% Writes log file with the clustering solution

    fileID = fopen(name,'w');
    
    [M,N]=size(data);

    fprintf(fileID,'CLUSTERING SOLUTION: \n');
    fprintf(fileID,'-------------------- \n \n');
    fprintf(fileID,'Data: %d samples x %d features \n',M, N);
    fprintf(fileID,'k: %d, ', k);
    fprintf(fileID,'Gstr: %.2f, Grex: %.2f, Gmin: %.2f \n', val.Gstr, val.Grex, val.Gmin);
    for i=1:k
        fprintf(fileID,'cl%d oir:%.2f, ois:%.2f, ', i, val.oi_rx(i), val.oi_st(i));
        fprintf(fileID,'|cl%d|:%.2f, ', i, rclust.cluster.mass(i)/M);
        fprintf(fileID,'r:%.2f, ', val.volratio(i));
        fprintf(fileID,'rho:%.2f', (rclust.data.Odensity*rclust.cluster.mass(i))/(2*rclust.cluster.mdDa(i))-1);
        if rclust.validity.mm(i)
            fprintf(fileID,'(mm)\n');
        else
            fprintf(fileID,'\n');
        end
    end
    fprintf(fileID,'\n Kindship: \n');
    for i=1:k
        for j=i+1:k
                da=rclust.cluster.mnDa(i)+2*rclust.cluster.sdDa(i);
                db=rclust.cluster.mnDa(j)+2*rclust.cluster.sdDa(j);
                dint=rclust.cluster.De(i,j);
                if dint>(da+db)
                    fprintf(fileID,'c%d and c%d are unrelated \n', i,j);
                elseif (dint>da && dint>db)
                    fprintf(fileID,'c%d and c%d are FRIENDS \n', i,j);
                elseif (db<da && (dint+db)<da)
                    fprintf(fileID,'c%d is a CHILD of c%d \n', j,i);
                elseif (da<db && (dint+da)<db)
                    fprintf(fileID,'c%d is a CHILD of c%d \n', i,j);
                else
                    fprintf(fileID,'c%d and c%d are RELATIVES \n', i,j);
                end                    
        end
    end
    
    fprintf(fileID,'\nOutliers: %d (%.2f %%) \n', rclust.cluster.outliers, 100*rclust.cluster.outliers/M);
    fclose(fileID);

end

