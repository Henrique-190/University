int contaFolhas (ABin a){
    if (!a) return 0;
    else if (!a->esq && !a->dir)
            return 1;
         else if (!a->esq)
              return contaFolhas(a->dir);
         else if (!a->dir)
              return contaFolhas(a->esq);
         else return (contaFolhas(a->esq)+contaFolhas(a->dir));
    }
