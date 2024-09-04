export const GET_ALL_PATH_DETAILS_WITH_SKILL_AND_STEPS = `SELECT p.id, p.color, p.status,
            (
                SELECT JSON_ARRAYAGG(
                    JSON_OBJECT(
                        'id', s.id,
                        'title', s.title,
                        'description', s.description,
                        'status', s.status,
                        'skills', (
                            SELECT JSON_ARRAYAGG(
                                JSON_OBJECT(
                                    'id', sk.id,
                                    'title', sk.title,
                                    'status', sk.status
                                )
                            )
                            FROM skills AS sk
                            WHERE sk.step_id = s.id
                            ORDER BY sk.sort ASC
                        )
                    )
                )
                FROM steps AS s
                WHERE s.path_id = p.id
                ORDER BY s.sort ASC
            ) AS steps
        FROM path AS p
        WHERE p.user_id = 30
        AND p.status = 'analyzed'
`;

export const GET_PATHS_WITH_TOTAL_SKILLS_COUNT = `
  Select 
   p.*,(
     select count(sk.id) from steps as s
     inner join skills as sk on sk.step_id = s.id
     where s.path_id = p.id
   ) as total_skill_count
   from path as p where p.user_id = 30;
`;


export const GET_ALL_SKILLS = `SELECT skills.* FROM skills 
      INNER JOIN steps ON skills.step_id = steps.id 
      INNER JOIN path ON steps.path_id = path.id
      WHERE path.user_id = ?`
