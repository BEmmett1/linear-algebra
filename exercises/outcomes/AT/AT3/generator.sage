load("library/common.sage")

class Generator(BaseGenerator):
    def data(self):
        # create a mxn standard matrix
        columns = 4
        rows = 7-columns
        rank = randrange(2,4)
        nullity = columns-rank
        A = CheckIt.simple_random_matrix_of_rank(rank,rows=rows,columns=columns)

        # construct variables
        xs=choice([
            [var("x_"+str(i+1)) for i in range(columns)],
            [var("x"),var("y"),var("z"),var("zw",latex_name="w")][:columns],
        ])
        xs_vector = column_matrix(vector(xs))
        free_vars = [var("a"), var("b"), var("c"), var("d")]

        #Get kernel/image
        kernel_basis=A.right_kernel(basis='pivot').basis()
        kernel_rep=column_matrix(sum([free_vars[i]*kernel_basis[i] for i in range(nullity)]))
        kernel_predicate = [LatexExpr(",".join([latex(v) for v in free_vars[:nullity]])),LatexExpr(r"\in\mathbb{R}")]
        kernel = setBuilder(kernel_rep,kernel_predicate)
        image_basis=[A.column(i) for i in A.pivots()]
        image_rep=column_matrix(sum([free_vars[i]*image_basis[i] for i in range(rank)]))
        image_predicate = [LatexExpr(",".join([latex(v) for v in free_vars[:rank]])),LatexExpr(r"\in\mathbb{R}")]
        image = setBuilder(image_rep,image_predicate)


        return {
            "columns": columns,
            "rows": rows,
            "Tvar": A*xs_vector,
            "varvector": xs_vector,
            "matrix": A,
            "rref": A.rref(),
            "image_basis": vectorSet(image_basis),
            "kernel_basis": vectorSet(kernel_basis),
            "image": image,
            "kernel": kernel,
            "rank": rank,
            "nullity": nullity,
        }
