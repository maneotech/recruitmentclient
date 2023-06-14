import 'package:flutter/material.dart';
import 'package:recruitmentclient/screens/base_screen.dart';

class UserScreen extends StatefulWidget {
  const UserScreen({super.key});

  @override
  State<UserScreen> createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  @override
  Widget build(BuildContext context) {

    return const BaseScreen(Text("Users"));

    //if role = superadmin on affiche les managers et les users

    //if role = managers on affiche uniquement les users

    //if role == user on ne peut pas accéder à cette page

    // l'écran est partagé en 2 colonnes de même taille.
    
    // sur colonne de gauche, les listes des utilisateurs cliquables, si on clique on a les informations qui s'affiche vers l'écran de droite

    // il y a un bouton pour créer un nouvel utilisateur. un superadmin peut choisir le role, un manager ne peux pas choisir le role (forcement user)
  }
}