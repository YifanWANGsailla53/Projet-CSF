clear;
Nu = 2;
m = 1;
M = 2;
NBits = 64;

message = zeros(Nu, NBits);
code = zeros(Nu, NBits);
message_encoded = zeros(Nu, NBits);
message_bruite = zeros(Nu, NBits);
received_message = zeros(Nu, NBits);
hadamar_code = hadamard(NBits);
tmp_hadamar_table = hadamar_code;

CONST = [-1, 1];
%%%%%%%%%%%%%%%%%%%%%%      �mission       %%%%%%%%%%%%%%%%%%%

for utilisateur=1:Nu

    %g�n�ration du message binaire
    Bits = [ -1, 1 ];
    message_index = randi([0 1], [1 NBits]) + 1;
    message(utilisateur, :) = Bits(message_index);

    %R�cup�ration du code
    [row, column] = size(tmp_hadamar_table);
    hadamard_index = randi([3 row],[1 1]);
    code(utilisateur, :) = tmp_hadamar_table(hadamard_index, :);
    tmp_hadamar_table = tmp_hadamar_table([1:hadamard_index-1, hadamard_index+1:end],:);

    %g�n�ration du message cod�
    message_encoded(utilisateur,:) = message(utilisateur, :) .* code(utilisateur, :);
end

%somme des utilisateurs
signal = zeros(1, NBits);
for i=1:Nu
    for j=1:NBits
        signal(j) = signal(j) + message_encoded(i, j);
    end
end   
 
%envoie de tous les signaux simultan�ment
%Bruitage canal
for utilisateur=1:Nu
        %G�n�ration du bruit
    Eb = 1;
    SNR = 40;
    N0 = Eb * 10^(-SNR/10);
    wk = sqrt(N0)*randn(1, NBits);
    message_bruite(utilisateur, :) = signal + wk;
end

%%%%%%%%%%%%%%%%%%%     Reception    %%%%%%%%%%%%%%%%%

for utilisateur=1:Nu
    %R�cup�ration du signal et d�bruitage
    figure(1);
    plot(real(message_bruite(utilisateur, :)), imag(message_bruite(utilisateur, :)), '*');
    for k=1:NBits
        for l=1:M
            D(l) = abs((message_bruite(utilisateur, k)) - CONST(l));
        end

        [X in] = min(D);
        message_dec(utilisateur, k) = CONST(in);
    end

    figure(2);
    plot(real(message_dec(utilisateur, :)), imag(message_dec(utilisateur, :)), '*');

    %D�codage Hadamard
    received_message(utilisateur, :) = message_dec(utilisateur, k) .* code(utilisateur, :);

    err = 0;
    for i=1:NBits
        if received_message(utilisateur, i) ~= message(utilisateur, i)
            err = err + 1;
        end
    end

    err
end