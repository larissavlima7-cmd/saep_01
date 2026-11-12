<?php
declare(strict_types=1);

namespace App\Models;

use App\Core\ConexaoBanco;
use PDO;

/**
 * Modelo de negocio para gestao de pets com vinculo mandatorio ao tutor.
 */
final class Pet {
    private static function pdo(): PDO {
        $cfg = dirname(__DIR__, 2) . '/config/database.ini'; //pega o banco de dados que esta no arquivo do config
        return ConexaoBanco::obterConexao($cfg);
    }
//lista os pets cadastrados com nome do tutor também
    public static function listarTodos(): array {
        $sql = "SELECT p.id, p.nome, p.especie, p.raca, p.data_nascimento, t.nome AS tutor_nome, t.id AS tutor_id
                FROM pets p
                JOIN tutores t ON t.id = p.tutor_id
                ORDER BY p.nome ASC";
        return self::pdo()->query($sql)->fetchAll();
    }
//pesquisa dos pets pelo id 
    public static function buscarPorId(int $id): ?array {
        $sql = "SELECT id, tutor_id, nome, especie, raca, data_nascimento FROM pets WHERE id = :id LIMIT 1";
        $stmt = self::pdo()->prepare($sql);
        $stmt->execute([':id' => $id]);
        $res = $stmt->fetch();
        return $res ?: null;
    }
//salva as informações dos pets no bd
    public static function salvar(int $tutorId, string $nome, string $esp, string $raca, string $dtNasc): bool {
        $sql = "INSERT INTO pets (tutor_id, nome, especie, raca, data_nascimento) 
                VALUES (:tutor_id, :nome, :especie, :raca, :data_nascimento)";
        $stmt = self::pdo()->prepare($sql);
        return $stmt->execute([
            ':tutor_id'        => $tutorId,
            ':nome'            => trim($nome),
            ':especie'         => trim($esp),
            ':raca'            => trim($raca),
            ':data_nascimento' => $dtNasc
        ]);
    }
//conta o total de pets cadastrados
    public static function totalPets(): int {
        $sql = "SELECT COUNT(id) FROM pets";
        return (int)self::pdo()->query($sql)->fetchColumn();
    }
}